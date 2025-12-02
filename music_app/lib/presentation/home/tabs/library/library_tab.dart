import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'library_provider.dart';
import 'playlist_detail_page.dart';
import '../../../../data/models/folder.dart';
import '../../../../data/models/playlist.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().fetchLibrary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thư viện",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Tạo Playlist mới',
            onPressed: () => _showCreatePlaylistDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: 'Tạo Thư mục mới',
            onPressed: () => _showCreateFolderDialog(context),
          ),
        ],
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchLibrary(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildFavoritesTile(context, provider.favoritesPlaylist),
              const SizedBox(height: 16),
              ...provider.folders.map((folder) {
                return _buildFolderTile(context, folder);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFavoritesTile(BuildContext context, Playlist playlist) {
    return ListTile(
      leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
      title: Text(playlist.name, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text('${playlist.songs.length} bài hát'),
      onTap: () {
        /* TODO: Navigate to Favorites */
      },
    );
  }

  Widget _buildFolderTile(BuildContext context, Folder folder) {
    return GestureDetector(
      onLongPress: () => _showFolderContextMenu(context, folder),
      child: ExpansionTile(
        leading: const Icon(Icons.folder_outlined),
        title: Text(folder.name, style: Theme.of(context).textTheme.bodyLarge),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'create_playlist':
                _showCreatePlaylistInFolderDialog(context, folder);
                break;
              case 'create_folder':
                _showCreateSubFolderDialog(context, folder);
                break;
              case 'rename':
                _showRenameDialog(context, folder.id, folder.name, true);
                break;
              case 'move':
                _showMoveFolderDialog(context, folder);
                break;
              case 'delete':
                _showDeleteFolderDialog(context, folder);
                break;
            }
          },
          itemBuilder:
              (ctx) => [
                const PopupMenuItem(
                  value: 'create_playlist',
                  child: Text('Tạo playlist trong thư mục'),
                ),
                const PopupMenuItem(
                  value: 'create_folder',
                  child: Text('Tạo thư mục con'),
                ),
                const PopupMenuItem(
                  value: 'rename',
                  child: Text('Đổi tên thư mục'),
                ),
                const PopupMenuItem(
                  value: 'move',
                  child: Text('Di chuyển thư mục'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Xóa thư mục'),
                ),
              ],
        ),
        children:
            folder.playlists.map<Widget>((playlist) {
              return Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: GestureDetector(
                  onLongPress:
                      () => _showPlaylistContextMenu(context, playlist),
                  child: ListTile(
                    leading: const Icon(Icons.music_note_outlined),
                    title: Text(playlist.name),
                    subtitle: Text('${playlist.songs.length} bài hát'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed:
                          () => _showDeletePlaylistDialog(context, playlist),
                    ),
                    onTap: () => _navigateToPlaylistDetail(context, playlist),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tạo Thư mục mới'),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Tên thư mục'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    context.read<LibraryProvider>().createFolder(
                      nameController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Tạo'),
              ),
            ],
          ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    String? selectedFolderId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tạo Playlist mới'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Tên playlist'),
                  ),
                  const SizedBox(height: 16),
                  Consumer<LibraryProvider>(
                    builder: (context, provider, child) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Chọn thư mục',
                        ),
                        value: selectedFolderId,
                        items:
                            provider.folders.map((folder) {
                              return DropdownMenuItem(
                                value: folder.id,
                                child: Text(folder.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFolderId = value;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Vui lòng chọn thư mục' : null,
                      );
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        selectedFolderId != null) {
                      context.read<LibraryProvider>().createPlaylist(
                        nameController.text,
                        selectedFolderId!,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Tạo'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFolderContextMenu(BuildContext context, Folder folder) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Sửa tên Thư mục'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showRenameDialog(context, folder.id, folder.name, true);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Xóa Thư mục',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteConfirmDialog(
                    context,
                    folder.id,
                    folder.name,
                    true,
                  );
                },
              ),
            ],
          ),
    );
  }

  void _showPlaylistContextMenu(BuildContext context, Playlist playlist) {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Sửa tên Playlist'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showRenameDialog(context, playlist.id, playlist.name, false);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Xóa Playlist',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteConfirmDialog(
                    context,
                    playlist.id,
                    playlist.name,
                    false,
                  );
                },
              ),
            ],
          ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    String id,
    String currentName,
    bool isFolder,
  ) {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isFolder ? 'Sửa tên Thư mục' : 'Sửa tên Playlist'),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Tên mới'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final provider = context.read<LibraryProvider>();
                    if (isFolder) {
                      provider.renameFolder(id, nameController.text);
                    } else {
                      provider.renamePlaylist(id, nameController.text);
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    String id,
    String name,
    bool isFolder,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isFolder ? 'Xóa Thư mục?' : 'Xóa Playlist?'),
            content: Text(
              'Bạn có chắc chắn muốn xóa "$name" không? Hành động này không thể hoàn tác.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final provider = context.read<LibraryProvider>();
                  if (isFolder) {
                    provider.deleteFolder(id);
                  } else {
                    provider.deletePlaylist(id);
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Xóa',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeleteFolderDialog(BuildContext context, Folder folder) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xóa Thư mục?'),
            content: Text(
              'Bạn có chắc chắn muốn xóa "${folder.name}" không? Hành động này không thể hoàn tác.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  context.read<LibraryProvider>().deleteFolder(folder.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Xóa',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeletePlaylistDialog(BuildContext context, Playlist playlist) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xóa Playlist?'),
            content: Text(
              'Bạn có chắc chắn muốn xóa "${playlist.name}" không? Hành động này không thể hoàn tác.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  context.read<LibraryProvider>().deletePlaylist(playlist.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Xóa',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToPlaylistDetail(BuildContext context, Playlist playlist) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlaylistDetailPage(playlist: playlist);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // Create playlist inside a specific folder
  void _showCreatePlaylistInFolderDialog(BuildContext context, Folder folder) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Tạo playlist trong "${folder.name}"'),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Tên playlist'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    context.read<LibraryProvider>().createPlaylist(
                      name,
                      folder.id,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Tạo'),
              ),
            ],
          ),
    );
  }

  // Create a sub folder under a folder
  void _showCreateSubFolderDialog(BuildContext context, Folder folder) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Tạo thư mục trong "${folder.name}"'),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Tên thư mục'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    context.read<LibraryProvider>().createFolder(
                      name,
                      parentId: folder.id,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Tạo'),
              ),
            ],
          ),
    );
  }

  // Move folder into another folder (or to root when null)
  void _showMoveFolderDialog(BuildContext context, Folder folder) {
    String? selectedParentId;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final lib = context.read<LibraryProvider>();
            final available =
                lib.folders.where((f) => f.id != folder.id).toList();
            return AlertDialog(
              title: Text('Di chuyển "${folder.name}"'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String?>(
                    value: selectedParentId,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Thư mục gốc'),
                      ),
                      ...available.map(
                        (f) => DropdownMenuItem<String?>(
                          value: f.id,
                          child: Text(f.name),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => selectedParentId = val),
                    decoration: const InputDecoration(
                      labelText: 'Chọn thư mục đích',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () async {
                    await context.read<LibraryProvider>().moveFolder(
                      folder.id,
                      selectedParentId,
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text('Di chuyển'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

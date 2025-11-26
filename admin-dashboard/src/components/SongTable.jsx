export default function SongTable({ songs }) {
    return (
      <table className="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Bìa</th>
            <th>Tiêu đề</th>
            <th>Nghệ sĩ</th>
            <th>Audio</th>
          </tr>
        </thead>
  
        <tbody>
          {songs.map((s) => (
            <tr key={s.id}>
              <td>{s.id}</td>
              <td>
                <img src={s.imageUrl} width="60" />
              </td>
              <td>{s.title}</td>
              <td>{s.artist}</td>
              <td>
                <a href={s.audioUrl} target="_blank">Nghe</a>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    );
  }
  
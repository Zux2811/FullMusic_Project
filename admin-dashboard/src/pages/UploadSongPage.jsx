import { useState } from "react";
import api from "../api/api";

export default function UploadSongPage() {
  const [title, setTitle] = useState("");
  const [artist, setArtist] = useState("");
  const [audio, setAudio] = useState(null);
  const [image, setImage] = useState(null);

  const upload = async () => {
    const form = new FormData();
    form.append("title", title);
    form.append("artist", artist);
    form.append("audio", audio);
    form.append("image", image);

    await api.post("/songs/upload", form);

    alert("Tải lên thành công!");
  };

  return (
    <div>
      <h2>Tải bài hát</h2>

      <input placeholder="Tiêu đề" onChange={(e) => setTitle(e.target.value)} />
      <input placeholder="Nghệ sĩ" onChange={(e) => setArtist(e.target.value)} />

      <label>Chọn file audio:</label>
      <input type="file" accept="audio/*" onChange={(e) => setAudio(e.target.files[0])} />

      <label>Chọn ảnh bìa:</label>
      <input type="file" accept="image/*" onChange={(e) => setImage(e.target.files[0])} />

      <button onClick={upload}>Upload</button>
    </div>
  );
}

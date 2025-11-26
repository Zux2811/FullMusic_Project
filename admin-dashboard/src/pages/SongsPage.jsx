import { useEffect, useState } from "react";
import api from "../api/api";
import SongTable from "../components/SongTable";

export default function SongsPage() {
  const [songs, setSongs] = useState([]);

  const fetchSongs = async () => {
    const res = await api.get("/songs");
    setSongs(res.data);
  };

  useEffect(() => {
    fetchSongs();
  }, []);

  return (
    <>
      <h2>Danh sách bài hát</h2>
      <SongTable songs={songs} />
    </>
  );
}

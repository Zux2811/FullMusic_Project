import { useEffect, useState } from "react";
import api from "../api/api.js";
import ReportTable from "../components/ReportTable.jsx";

export default function ReportsPage() {
  const [reports, setReports] = useState([]);

  const fetchReports = async () => {
    const res = await api.get("/admin/reports");
    setReports(res.data);
  };

  useEffect(() => {
    fetchReports();
  }, []);

  return (
    <>
      <h2>Báo cáo bình luận</h2>
      <ReportTable reports={reports} />
    </>
  );
}

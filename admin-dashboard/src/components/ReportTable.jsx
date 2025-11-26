export default function ReportTable({ reports }) {
    return (
      <table className="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Bình luận</th>
            <th>Người báo cáo</th>
            <th>Lý do</th>
            <th>Ngày</th>
          </tr>
        </thead>
  
        <tbody>
          {reports.map((r) => (
            <tr key={r.id}>
              <td>{r.id}</td>
              <td>{r.commentId}</td>
              <td>{r.userId}</td>
              <td>{r.message}</td>
              <td>{r.createdAt}</td>
            </tr>
          ))}
        </tbody>
      </table>
    );
  }
  
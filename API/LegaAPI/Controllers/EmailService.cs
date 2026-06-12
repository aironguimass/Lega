using System.Net;
using System.Net.Mail;
using LegaAPI.Services;

namespace LegaAPI.Services;

public static class EmailService
{
    public static async Task Enviar(
        string para,
        string assunto,
        string corpo)
    {
        Console.WriteLine("ENTROU NO EMAILSERVICE");
        Console.WriteLine($"Destino: {para}");

        var smtp = new SmtpClient("smtp.gmail.com")
        {
            Port = 587,
            Credentials = new NetworkCredential(
                "lega.support.app@gmail.com",
                "iavpjpsvtngdwexq"
            ),
            EnableSsl = true
        };

        var mensagem = new MailMessage(
            "lega.support.app@gmail.com",
            para,
            assunto,
            corpo
        );

        await smtp.SendMailAsync(mensagem);

        Console.WriteLine("EMAIL ENVIADO COM SUCESSO");
    }
}
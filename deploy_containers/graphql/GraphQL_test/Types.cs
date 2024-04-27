using System.Collections;
using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography;
using System.Text;

namespace GraphQL_test
{
    public class Blaze
    {
        public required String GUID { get; set; }
        public required string JSON { get; set; }
        public required DateTime CreationDate { get; set; }

        public static Blaze DummyBlaze() => new Blaze
        {
            GUID = "",
            JSON = "",
            CreationDate = DateTime.Now
        };
    }

    public class Response
    {
        public int code { get; set; }
        public required string message { get; set; }
        public Blaze blaze { get; set; }
        public List<Blaze> blazes { get; set; }
    }

    public static class BlazeStorage
    {
        public static int length = 5;
        public static int last_idx = 0;
        public static Queue<Blaze> blazes = new(length);
        public static String AdministrativePassword = "60B4429E9F48916A1D53356880F009D4B4E180A0BE0FCDEEC4B1FF4F5A3E9F5CFB3585303E82E18D3D1D9BDA012F96CE0B5B9A81490B8629411394C29B56DAD7";

        public static Response addBlaze(Blaze blaze)
        {
            Console.WriteLine("Adding the blaze " + blaze.GUID + " || " + blaze.JSON);
            if (last_idx <= length - 1)
            {
                blazes.Enqueue(blaze);
                last_idx++;
                return new Response
                {
                    code = 0,
                    message = "Your blaze was added succesfully :D",
                    blaze = blaze
                };
            } 
            else
            {
                Blaze last_blaze = blazes.Dequeue();
                blazes.Enqueue(blaze);
                return new Response
                {
                    code = 1,
                    message = "You added a blaze but you lost the oldest one :(",
                    blaze = last_blaze
                };
            }
        }

        public static Response getBlazesByGUID(String GUID)
        {
            if (GUID.Length > 0)
            {
                Console.WriteLine("Searching for blaze with guid " + GUID);
            }
            try
            {
                Blaze blaze = blazes.ToList().Last(b => b.GUID == GUID);
                return new Response
                {
                    code = 0,
                    message = "OK",
                    blaze = blaze
                };

            } catch (Exception ex)
            {
                return new Response
                {
                    code = 255,
                    message = "NOT FOUND",
                    blaze = Blaze.DummyBlaze()
                };
            }
        }

        public static Response getAllBlazes(String password)
        {
            Console.WriteLine("Trying to connect with password: " + password);
            byte[] enc_password = Encoding.UTF8.GetBytes(password);
            byte[] hex = SHA512.HashData(enc_password);
            string sha3 = Convert.ToHexString(hex);
            Console.WriteLine("SHA512 password is : " + sha3);
            if (AdministrativePassword.Equals(sha3))
            {
		Console.WriteLine("[!] Auth OK !");
                return new Response
                {
                    code = 0,
                    message = "Identity Verified... Here are our cute blazes",
                    blazes = blazes.ToList<Blaze>()
                };
            } else
            {
                return new Response
                {
                    code = 255,
                    message = "Forbidden",
                    blazes = new List<Blaze>()
                };
            }
        }
    }

    public class Query
    {
        public Response addBlaze(string json)
        {
            Blaze blaze = new Blaze
            {
                GUID = Guid.NewGuid().ToString(),
                JSON = json,
                CreationDate = DateTime.Now,
            };

            return BlazeStorage.addBlaze(blaze);
        }

        public Response getBlazeByGUID(String GUID)
        {
            return BlazeStorage.getBlazesByGUID(GUID);
        }

        public Response getAllBlazes(String password)
        {
            return BlazeStorage.getAllBlazes(password);
        }

    }
}

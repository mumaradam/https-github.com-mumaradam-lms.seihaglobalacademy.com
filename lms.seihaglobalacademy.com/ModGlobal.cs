using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace lms.seihaglobalacademy.com
{
    public class ModGlobal
    {
        public UTF8Encoding enc;
        public ICryptoTransform encryptor;
        public ICryptoTransform decryptor;
        public string holdDecrp;
        public string holdEtxt;
        public string sPlainText;

        public void loadEncryptDecrpt()
        {
            byte[] KEY_128 = new byte[] { 42, 1, 52, 67, 231, 13, 94, 101, 123, 6, 0, 12, 32, 91, 4, 111, 31, 70, 21, 141, 123, 142, 234, 82, 95, 129, 187, 162, 12, 55, 98, 23 };
            byte[] IV_128 = new byte[] { 234, 12, 52, 44, 214, 222, 200, 109, 2, 98, 45, 76, 88, 53, 23, 78 };

            RijndaelManaged symmetricKey = new RijndaelManaged();
            symmetricKey.Mode = CipherMode.CBC;

            this.enc = new UTF8Encoding();
            this.encryptor = symmetricKey.CreateEncryptor(KEY_128, IV_128);
            this.decryptor = symmetricKey.CreateDecryptor(KEY_128, IV_128);
        }

        public void DecreyptText(string in_str)
        {
            if (string.IsNullOrEmpty(in_str)) return;

            byte[] cipherTextBytes = Convert.FromBase64String(in_str);

            using (MemoryStream memoryStream = new MemoryStream(cipherTextBytes))
            using (CryptoStream cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read))
            using (StreamReader streamReader = new StreamReader(cryptoStream, enc))
            {
                holdDecrp = streamReader.ReadToEnd();
            }
        }

        public void EncryptText(string in_str)
        {
            sPlainText = in_str;
            if (!string.IsNullOrEmpty(sPlainText))
            {
                using (MemoryStream memoryStream = new MemoryStream())
                using (CryptoStream cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write))
                {
                    byte[] plainBytes = enc.GetBytes(sPlainText);
                    cryptoStream.Write(plainBytes, 0, plainBytes.Length);
                    cryptoStream.FlushFinalBlock();

                    holdEtxt = Convert.ToBase64String(memoryStream.ToArray());
                }
            }
        }
    }
}
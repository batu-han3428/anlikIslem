using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml.Serialization;

namespace topluVeriGonderim
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
      
        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text == "")
            {
                MessageBox.Show("Bu alan boş geçilemez..");
            }
            else
            {
                SqlConnection baglanti = new SqlConnection("server=DESKTOP-J0S4R9L;database=deneme;Trusted_Connection=true;");
                SqlDataAdapter dta = new SqlDataAdapter();
                DataTable dt = new DataTable();
                baglanti.Open();
                SqlCommand cmd = new SqlCommand("cekListele", baglanti);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@devir", Convert.ToDecimal(textBox1.Text));
                dta.SelectCommand = cmd;
                dta.Fill(dt);
                dataGridView1.DataSource = dt;
                baglanti.Close();
                baglanti.Dispose();
                dataGridView1.Columns[2].ReadOnly = false;
                dataGridView1.Columns[0].ReadOnly = true;
                dataGridView1.Columns[1].ReadOnly = true;
                dataGridView1.Columns[3].ReadOnly = true;
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
  
        }

        List<DateTime> tarih = new List<DateTime>();
        List<decimal> islem = new List<decimal>();
        private void dataGridView1_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            tarih.RemoveAll(a => a > Convert.ToDateTime("1000/01/01"));
            islem.RemoveAll(a => a > -10000);

            for (int i = 0; i < dataGridView1.Rows.Count-1; i++)
            {            
                tarih.Add(Convert.ToDateTime(dataGridView1.Rows[i].Cells[0].Value.ToString()));
            }
           

            for (int i = 0; i < dataGridView1.Rows.Count-1; i++)
            {
               islem.Add(Convert.ToDecimal(dataGridView1.Rows[i].Cells[2].Value.ToString()));
            }

            XmlSerializer xs = new XmlSerializer(typeof(List<decimal>));
            MemoryStream ms = new MemoryStream();
            xs.Serialize(ms, islem);

            string Xmlsonuc = UTF8Encoding.UTF8.GetString(ms.ToArray());


            XmlSerializer xs1 = new XmlSerializer(typeof(List<DateTime>));
            MemoryStream ms1 = new MemoryStream();
            xs1.Serialize(ms1, tarih);

            string Xmlsonuc1 = UTF8Encoding.UTF8.GetString(ms1.ToArray());


            SqlConnection baglanti = new SqlConnection("server=DESKTOP-J0S4R9L;database=deneme;Trusted_Connection=true;");
            SqlDataAdapter dta = new SqlDataAdapter();
            DataTable dt = new DataTable();
            baglanti.Open();
            SqlCommand cmd = new SqlCommand("cekListele", baglanti);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@devir", Convert.ToDecimal(textBox1.Text));
            cmd.Parameters.AddWithValue("@islem", Xmlsonuc);
            cmd.Parameters.AddWithValue("@date", Xmlsonuc1);
            dta.SelectCommand = cmd;
            dta.Fill(dt);
            dataGridView1.DataSource = dt;
            baglanti.Close();
            baglanti.Dispose();
            dataGridView1.Columns[2].ReadOnly = false;
            dataGridView1.Columns[0].ReadOnly = true;
            dataGridView1.Columns[1].ReadOnly = true;
            dataGridView1.Columns[3].ReadOnly = true;
        }
    }
}

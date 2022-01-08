using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

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

        private void dataGridView1_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            SqlConnection baglanti = new SqlConnection("server=DESKTOP-J0S4R9L;database=deneme;Trusted_Connection=true;");
            SqlDataAdapter dta = new SqlDataAdapter();
            DataTable dt = new DataTable();
            baglanti.Open();
            SqlCommand cmd = new SqlCommand("cekListele", baglanti);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@devir", Convert.ToDecimal(textBox1.Text));
            cmd.Parameters.AddWithValue("@islem", Convert.ToDecimal(dataGridView1[e.ColumnIndex, e.RowIndex].Value.ToString()));
            cmd.Parameters.AddWithValue("@date", Convert.ToDateTime(dataGridView1.Rows[e.RowIndex].Cells[0].Value.ToString()));
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

const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://grgcynxsmanqfsgkiytu.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdyZ2N5bnhzbWFucWZzZ2tpeXR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1NDkxMDQsImV4cCI6MjA4NjEyNTEwNH0.rlTuj58kCkZqb_nIGQhCeBkvFeY04FtFx-SLpwXp-Yg';
const supabase = createClient(supabaseUrl, supabaseKey);

const notes = [
    { title: "PLMGS 2016 Bio Prelim P2 MS", url: "https://document.grail.moe/f0c7aec4f29f44e2a4f38e1a7855e8c4.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "YTSS PURE BIO 1", url: "https://document.grail.moe/496e547573c54be4af3e56a005603cd0.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "YTSS PURE BIO 2", url: "https://document.grail.moe/4162c72e489947ef84368a69e289e954.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "YTSS PURE BIO 3", url: "https://document.grail.moe/727acf99964e4beebfa2ee460fe2148a.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "NCHS Bio Prelim P2 2024", url: "https://document.grail.moe/162ba6bad5174407a96f33d24e05f81b.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "NCHS Bio Prelim P1 2024", url: "https://document.grail.moe/cc213e43929146d89e826fe5abac3738.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "NCHS Bio Prelim P2 2024", url: "https://document.grail.moe/1efc689b58b54f7fb2844f5ea629a64a.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "NCHS Bio Prelim P1 2024", url: "https://document.grail.moe/e848aeb82f144f7b9f9399c5c25f5f8d.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "NCHS Bio Prelim P3 2024", url: "https://document.grail.moe/ba13c9d677934e968730f2425265e340.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "Bio AI 2022 Prelim Ans", url: "https://document.grail.moe/de3e4ff870084258a9890d6ef742c929.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "Bio AI 2022 Prelim P2", url: "https://document.grail.moe/0c2b5e9537fe4247a211577c49daf57a.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "Bio AI 2022 Prelim P1", url: "https://document.grail.moe/50e30db0e9df45749ae76f098396d06d.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "YYSS Pure Bio 2024 P1, P2, MS", url: "https://document.grail.moe/ab0fac8ba7aa446683b7b5780bde21f1.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "NCHS Bio Prelim 2024 Overall Mark Scheme", url: "https://document.grail.moe/32c60abe51a44c289924ffdffc19c9be.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "NCHS Bio Prelim 2024 Overall Mark Scheme", url: "https://document.grail.moe/e1ac28b68a48430cb385a48616344179.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "2025 FUHUA BIO P1 w/ ANS", url: "https://document.grail.moe/27c8e8ab7cb042ad9d27a840a50286fa.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "2025 FH Prelim BIO Paper 2", url: "https://document.grail.moe/625b96e7defd442db3324c17b9658f42.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "Mayflower 2019 Bio Prelim P2 QP", url: "https://document.grail.moe/91700b694ebe43f49dbb081a80affb6a.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "PLMGS 2016 Bio Prelim P2 QP", url: "https://document.grail.moe/d884277246484acc88cf26be950037e2.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "SCGS 2017 Bio Prelim P2 MS", url: "https://document.grail.moe/be0fc3e50bf5444a9fcc48b8ec1d76f6.pdf", category: "O Level", subject: "Pure Biology", type: "Exam Papers" },
    { title: "Zhonghua Prelim P1 Ans", url: "https://document.grail.moe/f155be6af9f543dea9ac1b26c8afc36e.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "Zhonghua Prelim P1", url: "https://document.grail.moe/e65ebc5089d647d78db204834bf370c7.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "Zhonghua Prelim P2 Ans", url: "https://document.grail.moe/50e510982143415f86b43c3b694c1c0a.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "Zhonghua Prelim P2", url: "https://document.grail.moe/29bca22ca0914e4089cd1fd5669e9ebd.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "YSS 4E Pure Chem Paper 2 Prelim 2024", url: "https://document.grail.moe/b057f5c389204285b0725f372cb58172.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "YSS 4E Pure Chem Paper 2 Prelim 2024 MS", url: "https://document.grail.moe/6df80160c9d146c5a4df787211ff6fef.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "YSS 4E Pure Chem Paper 1 Prelim 2024", url: "https://document.grail.moe/16fdc4d4c2ec4053934853c3b1c48464.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "YSS 4E Pure Chem Paper 1 Prelim 2024 MS", url: "https://document.grail.moe/6850010829ab4bd38a7672e6f942ee6b.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "Yuan Ching Prelim Ans", url: "https://document.grail.moe/aa13fff573594073af4621c07d3cc969.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" },
    { title: "Yuan Ching Prelim P1", url: "https://document.grail.moe/ae5f118ed7ef48b0be8660ec323a2536.pdf", category: "O Level", subject: "Pure Chemistry", type: "Exam Papers" }
];

async function sync() {
    console.log("Starting sync...");
    // Attempting to insert without user_id (public notes)
    const { data, error } = await supabase.from('notes').insert(notes).select();

    if (error) {
        console.error("Error inserting notes:", error.message);
        if (error.message.includes("violates row-level security")) {
            console.log("\n--- ALTERNATIVE: SQL INSERT STATEMENTS ---");
            console.log("Since Row-Level Security is enabled, please run this SQL in your Supabase SQL Editor:\n");
            const sql = notes.map(n => `INSERT INTO public.notes (title, url, category, subject, type) VALUES ('${n.title}', '${n.url}', '${n.category}', '${n.subject}', '${n.type}');`).join('\n');
            console.log(sql);
        }
    } else {
        console.log("Successfully synced 10 notes!");
    }
}

sync();

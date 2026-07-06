-- Run this in Supabase SQL Editor
create table credits (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  role text not null default '',
  image_url text default '',
  about text default '',
  topics text default '',
  links jsonb default '[]'::jsonb,
  created_at timestamptz default now()
);

-- Ei Maung
insert into credits (name, role, image_url, about, topics, links) values (
  'Ei Maung',
  'Web Developer & Author',
  'https://eimaung.com/img/eimg.png',
  'Professional web developer since 2006. Co-founder of Fairway Technology. Author of 18 books on web development, programming, DevOps, AI, and fiction. Passionate about sharing knowledge with the Burmese developer community.',
  'Agentic Coding · n8n · OpenClaw · Vibe Coding · Rockstar Developer · Professional Web Developer · JavaScript · PHP · Laravel · React · Bootstrap · API Design · Bitcoin · Ubuntu Linux · Programming for Kids · Lyra and Silent Frequency',
  '[{"icon":"language_rounded","label":"eimaung.com","url":"https://eimaung.com"},{"icon":"business_rounded","label":"Fairway Technology","url":"https://fairwayweb.com"},{"icon":"code_rounded","label":"GitHub","url":"https://github.com/eimg"},{"icon":"facebook_rounded","label":"Facebook","url":"https://www.facebook.com/sayar.ei.maung"}]'
);

-- Lwin Moe Paing
insert into credits (name, role, image_url, about, topics, links) values (
  'Lwin Moe Paing',
  'Frontend Developer & Author',
  'assets/lwinmoepaing.jpeg',
  'Frontend developer and community builder. Author of beginner-friendly books on HTML & CSS, TypeScript, and Figma for developers. Passionate about helping young developers start their web development journey.',
  'HTML & CSS · TypeScript · Figma · Frontend Development · Web Development',
  '[{"icon":"language_rounded","label":"lwinmoepaing.com","url":"https://lwinmoepaing.com"},{"icon":"code_rounded","label":"GitHub","url":"https://github.com/lwinmoepaing"},{"icon":"alternate_email_rounded","label":"Twitter / X","url":"https://x.com/LwinMoePaingDev"},{"icon":"facebook_rounded","label":"Facebook","url":"https://www.facebook.com/lwin.im/"}]'
);

-- Saturngod
insert into credits (name, role, image_url, about, topics, links) values (
  'Saturngod',
  'Developer & Creator',
  'https://avatars.githubusercontent.com/u/135177?v=4',
  'Myanmar developer and creator of popular open-source projects. Known for contributions to the local developer community through various tools and libraries.',
  'Open Source · Developer Tools · Community · Myanmar Developers',
  '[{"icon":"code_rounded","label":"GitHub","url":"https://github.com/saturngod"},{"icon":"facebook_rounded","label":"Facebook","url":"https://www.facebook.com/saturngod.blog.news"}]'
);

-- Min Pyae Kyaw
insert into credits (name, role, image_url, about, topics, links) values (
  'Min Pyae Kyaw',
  'Developer & Writer',
  '', -- TODO: set your image URL here
  'Developer and technical writer. Shares knowledge on software development, programming, and technology through Medium articles and community contributions.',
  'Software Development · Technical Writing · Programming · Community',
  '[{"icon":"language_rounded","label":"Medium","url":"https://medium.com/@saiminpyaekyaw"},{"icon":"code_rounded","label":"GitHub","url":"https://github.com/MinPyaeKyaw"},{"icon":"facebook_rounded","label":"Facebook","url":"https://www.facebook.com/minpyae.kyaw.73"}]'
);

-- Thet Khine
insert into credits (name, role, image_url, about, topics, links) values (
  'Thet Khine',
  'Developer & Writer',
  'assets/thetkhine.jpeg',
  'Developer and technical writer. Shares knowledge on software development, programming, and technology through Medium articles and community contributions.',
  'Software Development · Technical Writing · Programming · Community',
  '[{"icon":"language_rounded","label":"Medium","url":"https://thetkhine.medium.com/"},{"icon":"business_rounded","label":"LinkedIn","url":"https://www.linkedin.com/in/thet-khine-0a96051b/"},{"icon":"facebook_rounded","label":"Facebook","url":"https://www.facebook.com/thet.khine.587"}]'
);

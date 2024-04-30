Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CE21C2300
	for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 23:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521075; cv=none; b=kIDtJVjmVC9GyfNzFjt3Vt8dBh8dFAWjqjJ3nusfxVeSwGy144QuMzrtaSXI0k7H228FHB1s6d0pRP+DpdEiN6BusZDsP2vvpbELVPk7UnGDTObnYYI0JBnhwjuJHRldrFok5dGDFmZJtjaU+vJfTEccnY1p/NuNYjxR/9YctL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521075; c=relaxed/simple;
	bh=/OcbhMlACXwRbL6eMCAvatfg5p5nh1NZCgFVS7GD4sU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hnn2EurES4zrZNkc+m3XS2+mwvKbRWrLBQEoarhLXB7Upv4+Lt+XqTLO11NjKR2Lc3nmXGtMsG2TgxZxcY6z17wrtFNSsJ9CqRK9WBhHIsTaip45cLCwYV8q4B87RWQS1G17pK/0GyTEC/ozULAXqQrtbV1awWPtLEoz5tlyCy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MuiAn0/q; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MuiAn0/q"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b2ef746c9so116996797b3.1
        for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 16:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521073; x=1715125873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YOEM0xvLtojrhcgEFvmPYdUJPLv6ivSzHSsLdLUXzrI=;
        b=MuiAn0/qsBtu3KzYeWQ6rO0SKehAfnui30iwYKoNWfpt5LKwPXeceP3tXZ1Dh36CJV
         +HJ3D6AyRPPquGH7WVhc8jLK+6E+W8V34lcQMUZyEgfYiyXXNn8amasvLx5zxjRnqhip
         hPA8KsZMNuJhheC0i2LP8KB1c2KhlgxRB5KJjAmbz6Yjr4sCQbG+UuCfX5e0wzVjWhvV
         0+c8jtWHRxIYxPza8yXL8alsS1dyRAdqVExY5PL4V3HUlN/k5rSETrWWylh2NfA5uitp
         PWi8OJO/T4GyWtiamrxFEQS2NdLMj3maWYe9Rt5muEw3LUfB5hmOpIrRVeBBkZsGyN2i
         7/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521073; x=1715125873;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YOEM0xvLtojrhcgEFvmPYdUJPLv6ivSzHSsLdLUXzrI=;
        b=LjQULIZ9Tzk9G2S3Q5ttuejWI9zTB/NefU21SG5+VbzDwhSwARCGL8rUqLHJRsqCEF
         p59SyWAy7Vk5AdY2B/V77mG2UMH1Qa4uWnZPU+TNIMcedsKKJuafkdMgPhO4PWUTDx9W
         u0sl1RFLQvwg8iP6sgVAVhZCyEkxZUoi8aAPDJHNPdGTo23H+PbUImmO25wXpugvpj27
         DcYZ+e5Xw56VaxrrlOt/d8Yg2EuIthXbvr4e5l16eAdBTHA8AMC7Qwks3khld30qtFqH
         IHCfw8MuTx4EDKj8PvY3oiTneIeaG/wGEOyPVjBcD83paU1f775hKTu782Ljv53I5OQe
         P9PA==
X-Forwarded-Encrypted: i=1; AJvYcCU8qTC4hr+Ng9Bly2nhOanJbpcFSnSjH7AT9kzcUN5dNSAborg1GJT3+NVPtWhLNMButNQQTaPn66Cq34XDnOJMZiZlzW6fIhh/
X-Gm-Message-State: AOJu0YxwuUaM+IK76nSz7gKJjxeW/8O/O0pKTRcmXV4SGAnZmVESNc+s
	0GHcxpoDFDHRa5EsQOMUDm6kJlk59GZ+kdwMWbfC4xAkAJkDSnbX3h1HNRiXhA2AkGmBr2d/z+s
	dQg==
X-Google-Smtp-Source: AGHT+IFJXIs/Lt+BtxjY7jBxKzzWVBtTxh64x30GUOCc5Tw5J5fH56D2Gr2lUi2tRLPjityAGVOjM5YrN70=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a0d:d614:0:b0:61c:89a4:dd5f with SMTP id
 y20-20020a0dd614000000b0061c89a4dd5fmr271833ywd.0.1714521073133; Tue, 30 Apr
 2024 16:51:13 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:09 +0000
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-1-edliaw@google.com>
Subject: [PATCH v1 00/10] Define _GNU_SOURCE for sources using
From: Edward Liaw <edliaw@google.com>
To: shuah@kernel.org, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Bongsu Jeon <bongsu.jeon@samsung.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Edward Liaw <edliaw@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@android.com, linux-sound@vger.kernel.org, 
	linux-input@vger.kernel.org, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
asprintf into kselftest_harness.h, which is a GNU extension and needs
_GNU_SOURCE to either be defined prior to including headers or with the
-D_GNU_SOURCE flag passed to the compiler.

Edward Liaw (10):
  selftests/sgx: Compile with -D_GNU_SOURCE
  selftests/alsa: Compile with -D_GNU_SOURCE
  selftests/hid: Compile with -D_GNU_SOURCE
  selftests/kvm: Define _GNU_SOURCE
  selftests/nci: Compile with -D_GNU_SOURCE
  selftests/net: Define _GNU_SOURCE
  selftests/prctl: Compile with -D_GNU_SOURCE
  selftests/rtc: Compile with -D_GNU_SOURCE
  selftests/tdx: Compile with -D_GNU_SOURCE
  selftests/user_events: Compiled with -D_GNU_SOURCE

 tools/testing/selftests/alsa/Makefile                   | 1 +
 tools/testing/selftests/hid/Makefile                    | 2 +-
 tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c | 2 ++
 tools/testing/selftests/nci/Makefile                    | 2 +-
 tools/testing/selftests/net/bind_wildcard.c             | 1 +
 tools/testing/selftests/net/ip_local_port_range.c       | 1 +
 tools/testing/selftests/net/reuseaddr_ports_exhausted.c | 2 ++
 tools/testing/selftests/prctl/Makefile                  | 1 +
 tools/testing/selftests/rtc/Makefile                    | 2 +-
 tools/testing/selftests/sgx/Makefile                    | 2 +-
 tools/testing/selftests/sgx/sigstruct.c                 | 2 --
 tools/testing/selftests/tdx/Makefile                    | 2 +-
 tools/testing/selftests/user_events/Makefile            | 2 +-
 tools/testing/selftests/user_events/abi_test.c          | 1 -
 14 files changed, 14 insertions(+), 9 deletions(-)

--
2.45.0.rc0.197.gbae5840b3b-goog


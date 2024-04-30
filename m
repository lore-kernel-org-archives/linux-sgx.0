Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA9B1C68BF
	for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 23:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521086; cv=none; b=KOHGewsQSxcQmGH0iZkxAjUqylJD9msCXaOZoE8t3VPZ7QNOM9OWuyIo9SSZeY8MzfZ/4D6wluzq2ABlHnzVRBRJ/2NHyAlugxZU78H0iBFzISuaiiHbyZFeU1yvcX2juRrsE2oxYaU1kgE4M9KivsXdhDCdAw+vDjeackmko70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521086; c=relaxed/simple;
	bh=sTlQvY8lGvZPuHB/3EseuBYDvbUHarzxjj1L20e4VZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IEIGoC42hL4AZD+eLaYZiKAQ08KahZgPOvGV+FAemOXOIvwPWu6bSXbycGjWwcUQTuP8nkwYrk63tanCUsPenMSot8AB+YahJ6JNd2gKycs4OkUMBPQ5rccxZFoChOr5JdwNsXXZWzHFhQxb8/B+yo4Ivfwwrlge61WEpBPqn8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ODSADp1e; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ODSADp1e"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de5a8638579so8485398276.1
        for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 16:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521083; x=1715125883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sTlQvY8lGvZPuHB/3EseuBYDvbUHarzxjj1L20e4VZQ=;
        b=ODSADp1eQFRbLl7nhYE49t5GM9KuSLfgYomKkoF9iWuHEzWau6DhGOjqNHOUpQZGM2
         NWtqQgb54VX1JOivCc/iUQhtdarwuM/7QtIihGsvxBhlf/4hrMAmcL9gsw2R8BFol3cy
         2h/lsq6jdaQL3XSHKvpbWXNB5vYpnRqXR61wDBDDRBZfEpDEIrXkVxXDFcA5z0aJnANY
         4CmmN+eo1ilWwWzJKNdUsoC+D6ORCV3/dMVilJOc3QJCpfze0Rd6n7X8tjbBsfug9x64
         OPDdDKB/6P8jGdO1kglkHg+mnRDnpJ9bSHdFxznGnqosvzFr34w4OQGU3MxPW18oyqQd
         LzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521083; x=1715125883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTlQvY8lGvZPuHB/3EseuBYDvbUHarzxjj1L20e4VZQ=;
        b=bGUESvaf+qb7k0hjKcFz8NSlzDYk4veTsTHwHWK8wOpYK1d+i9wGO1tBwwg2lgMCyz
         NbhkHJNvXRaU55FMcjAteXyPrLTLa4a80jY959DVg2ZavWkXXZncIotF8G4F0JvSOazY
         so+WEOdscmZVDRPq0rN97uUMp+epi5vxEJPKXmTSNG7OfkXibdsY5057NdL7+rTvLD9F
         iQZzvcDynolCdSmiq7lumv+epa/Kj39NNqfFM4iHU4RNoeruKfLKhrKRZxHUrGmWgu/1
         DWvrdC5T1/UDAbATF5xyq9Phe7yDU1Ah8QXdf0FUdmbS7dD2zplWHGTFqRiPQTvOMpRb
         z8Ag==
X-Forwarded-Encrypted: i=1; AJvYcCVvt8d88RZW/itTOR24zqsWlM9qrSQ0abW5SO/ICGEfuhw2kCSqBE/15ba4b6VAueWDArBQzt+Xx0QvAkwc1C6VjVyN2lFg0u4D
X-Gm-Message-State: AOJu0YwZqdywUlHUcYpGykXmLL++Xn5Kku6KulPda88Odz1uUC/4+COO
	xCrBbPmLZEm5LNEI7WofF8nSV4yp7jAK07IrKqWRaqqu7ymZDcx8l/q3tMAgZdRvai3HM0ej2fK
	v9g==
X-Google-Smtp-Source: AGHT+IHawjnD3ivyqCv4ps9nkMuRCo5h/TV1o9YMssrnDwBNMjv0tpGZfKkbqtk/WfPC4jw/0Gs09BBrmvI=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:2b8c:b0:dd9:1b94:edb5 with SMTP id
 fj12-20020a0569022b8c00b00dd91b94edb5mr161630ybb.10.1714521083148; Tue, 30
 Apr 2024 16:51:23 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:11 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-3-edliaw@google.com>
Subject: [PATCH v1 02/10] selftests/alsa: Compile with -D_GNU_SOURCE
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

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/alsa/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/alsa/Makefile b/tools/testing/selftests/alsa/Makefile
index 5af9ba8a4645..3a0fae2bea39 100644
--- a/tools/testing/selftests/alsa/Makefile
+++ b/tools/testing/selftests/alsa/Makefile
@@ -6,6 +6,7 @@ LDLIBS += $(shell pkg-config --libs alsa)
 ifeq ($(LDLIBS),)
 LDLIBS += -lasound
 endif
+CFLAGS += -D_GNU_SOURCE
 CFLAGS += -L$(OUTPUT) -Wl,-rpath=./

 LDLIBS+=-lpthread
--
2.45.0.rc0.197.gbae5840b3b-goog


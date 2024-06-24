Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19401A38DC
	for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 23:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271799; cv=none; b=tDXVSsHArksELOmUE5C3Bb62e18DNtPEEMC6VUl0PFRRgVpu+1vgurq6UUh4LsE4jzqJ8T3A9+ZOC0oKNEJE3GY7mJW1VcluZEh50mBATpHkzoIxKdFF6oa6pwlqfOxPUngz5W++pddIiPdIL77RS7ioLgW+Yymf3FBxh9c5Yv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271799; c=relaxed/simple;
	bh=VPZXh7x1OhxAHC0bXKoLWNX1SyyNKVGyVHKLwXltTVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ColKe604TBzGDjTgaTGnMVyDQMnb8s4TR/xTd58XVjdwN+U+an3U/PXb93KEYTPWw4lcZHc++ddfNRJIsihO1bQq5llpkkM7Kh1/yccgpeNL90ZAWriYb0AOm8VqbcWOKBhsMkzJ3KhYtuOQXwJlvtz7tnNz/knNnfH41ZgF+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JduUbGIg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JduUbGIg"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f6174d0421so52231725ad.2
        for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 16:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271797; x=1719876597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/nRYsPHuTaGMizrWA3B3ZZLI9bMolsQdLa0Lqckx8I=;
        b=JduUbGIgmJbfxGF7qOmldmm8FhJDwdyAETPaMZoBHgcayySnJNg6tJ4/3S9X0P69rL
         XmMXDNKslIvQSayblAvjO1N7oerh4f5WJcdcrLR7XKDzaxxl/Q5tMf4St3ceKkfymamk
         EQAysOgtfT2AvsGu1VfQ5ibMiXJKxysL+MgprmHpSerK23HXaD36Bx1WxKTyekz6+KTY
         XxDx8wihq9nxE22eSjprVRGL38i/pyVSsNvxvOCJEDoFSPCWuQ6xtu6irk59XMEd3N/V
         DCo4NXJKi0vS3OO+HGEBxQ0zO0soW0H492s/BbJrma6hDaPgarh8TfVRPRD4CiFab43a
         U6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271797; x=1719876597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q/nRYsPHuTaGMizrWA3B3ZZLI9bMolsQdLa0Lqckx8I=;
        b=l96/2ZDY7Yo/pvXoAVS7RRVdZabiCy2U5j8MzTErcQAAKskQGxbd26cCaQI0w1PGZH
         1ch6q2Sg91E8BHHnNAC7hseKRLBujVJv2ihfXNnT95lPAW6Z5XsSrltIjXC1ZmrxoeWh
         21SWO6qsbr5O7a6sO6ebn4lAtqkWz27kDsQVgskwNsGow5kH318S92NB9IQ5w7rIY6fZ
         KndOr5s6td2wPS+VSyIfbcpE8oSfXBbVPHuTdfvG1mm9fqjZTFtPN//dUIRZYfozStlx
         A7soKnZuKRpcut74KQJcDKwKDnVLk/OgACWLpev8xD9KxTiHVTy+CSHK0Dw5VPj4Acox
         VHEA==
X-Forwarded-Encrypted: i=1; AJvYcCURDIe9goLLzES/auUN3gAM3e+62m/PLTb031Vyg7lcfeC4GC0c7cPUTbkzmK6S59LYZDJUcn7a/Gwk1ajfg5EjnTIj4Sf050Nf
X-Gm-Message-State: AOJu0Yz0BSpsXgxsFZqXaI8tIJCSIYrSKEaGaoFWSWGFf3JkqQbc5VHw
	ID46Zseq+/EK0dWsQs1x9/Jk9e96qHlWTivnvtk7GxP5N0TDE8EoZiPOafsC9tPYX9nA3e9/mCB
	r2Q==
X-Google-Smtp-Source: AGHT+IFZmU35y+9sHVYjgBtLmkHsjpVEfz9mzouhtaAmWQwnWgKPMl1MuSAOaM0VtiMXYbYfw881ubbrmb4=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a17:902:f707:b0:1f7:3170:5c4 with SMTP id
 d9443c01a7336-1fa1592da1fmr6098675ad.10.1719271797169; Mon, 24 Jun 2024
 16:29:57 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:20 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-12-edliaw@google.com>
Subject: [PATCH v6 11/13] selftests/ring-buffer: Drop redundant -D_GNU_SOURCE
 CFLAGS in Makefile
From: Edward Liaw <edliaw@google.com>
To: linux-kselftest@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	"=?UTF-8?q?Andr=C3=A9=20Almeida?=" <andrealmeid@igalia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, usama.anjum@collabora.com, seanjc@google.com, 
	kernel-team@android.com, Edward Liaw <edliaw@google.com>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

-D_GNU_SOURCE= will be provided by lib.mk CFLAGS, so -D_GNU_SOURCE
should be dropped to prevent redefinition warnings.

Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/ring-buffer/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/ring-buffer/Makefile b/tools/testing/selftests/ring-buffer/Makefile
index 627c5fa6d1ab..23605782639e 100644
--- a/tools/testing/selftests/ring-buffer/Makefile
+++ b/tools/testing/selftests/ring-buffer/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -Wl,-no-as-needed -Wall
 CFLAGS += $(KHDR_INCLUDES)
-CFLAGS += -D_GNU_SOURCE
 
 TEST_GEN_PROGS = map_test
 
-- 
2.45.2.741.gdbec12cfda-goog


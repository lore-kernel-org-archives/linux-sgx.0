Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A31A2FB6
	for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 23:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271771; cv=none; b=P0RJf5OiFEcuWhus/jMEglPgdXH6pNfdn2l+ntloWNu86W5uNiOXKo6pU0dPwuuBJkYvJX+Zvg4PDhVvG9w1hwlV0O3itQ1kU4sDm7pNsLhknESuqDwwn60dn7syXIrHWGGYSkgT8CekZyaVi2Nsj5HRF6Awi7sF+ZiLChH8b8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271771; c=relaxed/simple;
	bh=X0lnJ8lH8/hxDl4Hg4Bojyv5HWdI5Bnk/QcwrFlBWSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OlbwRfeXjhzEPckMLVV8tmqXQvdbqFqWMOUMoBrPyEqOpthOf5cCyLkTYuT8pWCy4TRsKsayIIJGbgN3OEx6dzONjCVdcYD9G366fjrcU7S8v9Waa8EhT006wVTdWSC0zKCO9tje8/QAmXmT8Lk3k8aviwvD88YE9kdBui6ji8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ohzbnry+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ohzbnry+"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-706694428e3so1770542b3a.1
        for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 16:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271769; x=1719876569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ifr8Ya8A/Lifd4HdrItZMFbfd7FCXsltsIVIxxyLaY=;
        b=ohzbnry+JMaNI/LoAVkSbzXCxw5B/o4CS1UrO+nJVwOmdsBozrcw6UNZdQtSv2b/Bw
         k/BpVfvnuno4LWJ2jPwF8+MT9j8DuAtz7X0sTBLCpCdtORcM+3HrGcEfLlHokit04i1u
         8Bb7PRWnvHGHz6Ir13r8eM44Bu2X0lxzXWMsqkaXE5vMzwm6kx5fGMsm84lggv6qVD4b
         R8Djp70eCmMI1lGY0DAbr1s0JUkOzy212bhpU95ikpolBWMnJ/MOKq/UAEVK43SHNHeA
         4zLUw/HQcnOvQPlTkC5nfKfO4msLeojR5nw7lK2lYXF4BSeEhneEGlh1Mn2zRKTbLFxn
         RDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271769; x=1719876569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ifr8Ya8A/Lifd4HdrItZMFbfd7FCXsltsIVIxxyLaY=;
        b=cNilGmbGzzw38AN6JlEj2VF9iFYwWuWWTIuZOU6Cxt0FonruxFTUZnYTfup3RJtUEU
         9DN8I3rJ/BSI0cCq5J7DDhGFHROwUeyZpAFng97EeXkflI/9AwnWASYJsCJuXYq7i7tq
         uN5FrrhxxL02Aj15boed/fO4z+ZmDOsy28calGrqi90IvqgRtUphOWljSugL8nhxzyAd
         udwwXxn5dYO6N4hVJADliRuWDNe9ffnzM1dUNSoYNo59tnQMrrgXXpcWasrRe1n3l8go
         nBKwbrgglCoI78nmsi9LhY6ZLttP3VQdAhL70lCl1AWt9LHYYivnmwucdmHFMLnjzSkd
         UeRg==
X-Forwarded-Encrypted: i=1; AJvYcCUWAajl+v+BM6EBRIu6Q9XCBkgWE9B/0CNJ/fOvlTp5CgpwFE31/UfXtS9ZbxD0n1/ho2TZ/3csVeubmRB3/pushJghCPK8MtI7
X-Gm-Message-State: AOJu0YznPQEtEFP/+C65zBl/iAi3ReF3VimVEJ4ofmosbuUmQAdeIJlX
	XQynHnBMpKgJYjdBoY5uAx5pcPDf7MGBR1OTag+z3WgO7Pq9JfT0DpqxTuiob2LKVasUZGjStCD
	EJw==
X-Google-Smtp-Source: AGHT+IGfwxTfgoKpQbwyVdHdeu4Fayfp12bseSCI+21TX1FuKt23v8wGVL/xanJWyhgjJiFfoB7TugWlGLo=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6a00:898e:b0:706:3433:bf21 with SMTP id
 d2e1a72fcca58-70669dfcfdamr31477b3a.3.1719271768844; Mon, 24 Jun 2024
 16:29:28 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:15 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-7-edliaw@google.com>
Subject: [PATCH v6 06/13] selftests/intel_pstate: Drop redundant -D_GNU_SOURCE
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
 tools/testing/selftests/intel_pstate/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/intel_pstate/Makefile b/tools/testing/selftests/intel_pstate/Makefile
index 05d66ef50c97..f45372cb00fe 100644
--- a/tools/testing/selftests/intel_pstate/Makefile
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
+CFLAGS := $(CFLAGS) -Wall
 LDLIBS += -lm
 
 ARCH ?= $(shell uname -m 2>/dev/null || echo not)
-- 
2.45.2.741.gdbec12cfda-goog


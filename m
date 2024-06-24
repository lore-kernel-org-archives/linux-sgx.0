Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBD11A2FBE
	for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 23:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271744; cv=none; b=FCf4iJBVVMOcnNCVa0exCMyzIOl/nPnVnfAQiUnIkzp2xNrxgVCUwp9inLAkuThqXvfidsWuc1kKD3hH7Mkh08s4M9eEPScF2GqXg1YzI3ueMMacamgCQTkhvBe3ICnzkYF1Yr0ilCVlDhPIMZQsmZQwb1sdPeZMoyMz5svPuV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271744; c=relaxed/simple;
	bh=NqMqA7QWqr9/+mHOdPi0hG2A/sBfX5GGxqySZ84bEFo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g1MhUM86OHH2xynHKcb5Ap3kw6caLreDfiHGUSZJMHdC0GK+WxIUsYuRyTUEfl+LqQLbbRCcfKZnyiDgs4/KiMUD4uYjqMit0FobVFsylKtQrRTX+95uKo6T5tTt6hHDVAut1lRQWQq1EJfQSNnfshA7kiJ5eyn6mn3vEb7dftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fFnZmnvw; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fFnZmnvw"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c380e03048so5788539a12.3
        for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 16:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271741; x=1719876541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3FvMNQZepmevKVYCWA5Mvt/tIAvZEAV28z8ZXGZ1r5A=;
        b=fFnZmnvwS7MKFZpI2jZMbCpkc1fBRNSkoC0KwtyJ//fyUSbZ5X7qFRT22trNVHNbwH
         7hKGXsTVw8DsxkPINXp4UyNONQ0xtStZnBMMB50Qz0DqWUW4UIMVG71me7g/KZzsf1p9
         iLgKVe7bNnsQVW3vMyqwwum4CvlzWjxiFZ1HfNScTjY/HG4RO1YDuK0/fIJgQI0er74i
         YQe5HcwABIwTtd60FVLPOwNe8zOvM6GlKnmAhSomrs0eDER+eGosM9jV0exbdhtsCTYg
         fP2AaGSFbYc4PQEvAIRaVPD/220sTNF2RIhdRVfy5cFWDBz0R9+HThNNdPmt1AzPkhBU
         1dGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271741; x=1719876541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FvMNQZepmevKVYCWA5Mvt/tIAvZEAV28z8ZXGZ1r5A=;
        b=DhLoCIGPDQJqCSuSXqsEc5AIvdqUlneVRZQqYKKuAllkz562uV2eY+KQpQE+emRuB0
         Wd4y+WQbkgdgc+EJFiCI0O5JGKCj2vtBSo9XImhNSjLOFJSBzTaCxnaESVdFbXrJdwJu
         1KAgM8Ydqy9WHOAKYQAfYOsMKWTXdVLShdQTvOtJ+/IvaIFDk7OcmGTZhCpcEvkVmmAC
         4+GXR5QuGWgpYyEqZycyxv7t50h0/MZ/h/QVUuATRmwklErBVGKg+Jrg5/TKetIx9FDv
         rAavNvZc8S6oZ0rx3wyGin1+1++XHVUCZfx/1xQvXNfuIz0Buow+2/2TyLs6DI55BB6i
         cigw==
X-Forwarded-Encrypted: i=1; AJvYcCUGvmRLUwGLmfmOpjtG8hQeuLTFz9MygVPWRKnIb7P20xKvtL2vEjPEljObR+tNGj5lmBlp9lbUzdeCrBV8WRooJHup7/e5ybqR
X-Gm-Message-State: AOJu0YzZ/NpzBv8gD8Li8J4Ni/AXtve98bGHp/uMncno8zB3i6jNfk40
	5FUPhCYUDkKpmSkqxlUDEQs7NO2jvemjAbFwa/MDO8DhaKP/M+XEDQeAmJ9GOTtU5slknCDRqtO
	5Hg==
X-Google-Smtp-Source: AGHT+IEk+3lC5zdyxifyt4ii+6a16n1y8uZeO7DOAPkbXtiVBPE0qfgp7g0LpuESyv8BZuXBXF4M/RvaOF4=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6a02:4a7:b0:655:199c:eb1b with SMTP id
 41be03b00d2f7-71b5fe10537mr20071a12.10.1719271741168; Mon, 24 Jun 2024
 16:29:01 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:10 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-2-edliaw@google.com>
Subject: [PATCH v6 01/13] selftests/mm: Define _GNU_SOURCE to an empty string
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

Use the more common "#define _GNU_SOURCE" instead of defining it to 1.
This will prevent redefinition warnings when -D_GNU_SOURCE= is set.

Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/mm/thuge-gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index d50dc71cac32..e4370b79b62f 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -13,7 +13,7 @@
    sudo ipcs | awk '$1 == "0x00000000" {print $2}' | xargs -n1 sudo ipcrm -m
    (warning this will remove all if someone else uses them) */
 
-#define _GNU_SOURCE 1
+#define _GNU_SOURCE
 #include <sys/mman.h>
 #include <linux/mman.h>
 #include <stdlib.h>
-- 
2.45.2.741.gdbec12cfda-goog


Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EFC1428F1
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757686; cv=none; b=n75gFdklMTDSjoVVPtAhD4sJ5dSHrJlQ49rpjQzYoBWPBtNd6+TmLp64faaW/rPUdrs/qxx0U7EKBg5JZj+0s4HAXmqq+fSUxHhhcpI1Ik3ArGzWqlfMl0Sx9gGXDluE6K8uqKZ8V3YVLOXj3Yc9ZKHj5r2i40Unj+MH5YtFF7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757686; c=relaxed/simple;
	bh=SfTqWTXa8BKoYVN/v8dEJW0W+ZanJ5NwKZHbFFSkXUA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QoGyA7hHyfDoR7nsFiAWeedDiiM4gDMKx3qK6WOGjGznevpCCDNdQ+tMY6nUzMh5rF+xj1nQCsWQT+FIH41L+8xd1OhHnrTXKc0+e34/FK7STwgejkLlrZZFpvyHR6ZvrsdFjjNxf7xRne69dGv+xFOYQzpuC5Fq6LMne9gp0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2aUZ6RFw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2aUZ6RFw"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee0c9962daso353321a91.2
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757684; x=1733362484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G70La0fxRWvS7O6Qk47ARCLzL+vhxpEYYaoXHV45TwU=;
        b=2aUZ6RFwCXBMpKeUusYBJ01/e2fzpimey+Hqxktx3CGpqbqOfYjq4wK9OjZY+HaTDU
         LyAETmWV89bGrzV0kq+PoSREPh0jUpTickq2K8qnTzHJVNgzMrIEjXFzWF5ogVP1d/T1
         SYTdC0kRjpjKlhFAcCfI7kIVUv8c7faxEAxgn2qwhZlPd0UC0oCiRw4rv1bPK3uu9gh+
         XWLsXAMhY7fBgExwQ43j3+rLVpOqdaDS2OEfPP90H+Ye6ZrYsqBtvHXsb3ozeHhYQYUU
         HRAwFoPImLMwS/YLnCwDH+rNsC+N7EbkY8rrfVh2lJD6438a28foNFNCpE6fyt0HSSf3
         auvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757684; x=1733362484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G70La0fxRWvS7O6Qk47ARCLzL+vhxpEYYaoXHV45TwU=;
        b=UuyCH0hC0KxCIx7wKc04sLXS5cXsvehS5gW/0r3R5dmtNvWy4+6X55eQpdeANHdW+f
         PlN5pFbznJ+PJCCIHOWNwQtpRtlWT8f3dtyGFeKrJcJNfMWkB3R8FNy9QU0n+eoWIhXf
         5dm0IvfZbWi4+e6PEQAwqgFvwX0akR7mwHZT+T/vwnMbmGNcSJu+OSgHenbzEIjcd7xu
         G3cjsYET5rWYGrUTRjm8savgKArJwf7nOkzl2Eih5j6mpxc9crGoua02Sqr9h6VGXnlu
         eOYsH7vB676Wuc/ZDwoyWTHIXsKgGUXRqVDJ2BqthVAITMYgUGdEb/R9Hfc00woK7i5t
         hNfA==
X-Forwarded-Encrypted: i=1; AJvYcCX6ITID4J4647J2SRi98KPbbI/ecOtFfUgzVTuEzFWAGoLcGTZwFaYVxU1wXLYKXiNeuh4Q0NTvbXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE6+8AnkZDsjW3JyXchDHaG8b7sdRpvoux9O9dpkvtavR9YMgb
	/l7VLBXE3Yl1QpUPMWU6ZIEFa5hu5PJP8ju2f00WiK/WABk8fxel7GBLuhUgZqLHjjhZc5spIAV
	iyQ==
X-Google-Smtp-Source: AGHT+IFToGV0nK6Lp298fFzAmw75HCs6XdDNudr1ZEVggFnYIEoMGXjFW2pcMaufdLz9kGjCHOkick7/ql4=
X-Received: from pjbqn14.prod.google.com ([2002:a17:90b:3d4e:b0:2ea:83a6:9386])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b8e:b0:2ea:8fee:508d
 with SMTP id 98e67ed59e1d1-2ee097bf308mr6780563a91.30.1732757684358; Wed, 27
 Nov 2024 17:34:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:34 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-8-seanjc@google.com>
Subject: [PATCH v3 07/57] KVM: selftests: Assert that vcpu->cpuid is non-NULL
 when getting CPUID entries
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add a sanity check in __vcpu_get_cpuid_entry() to provide a friendlier
error than a segfault when a test developer tries to use a vCPU CPUID
helper on a barebones vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 645200e95f89..bdc121ed4ce5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1016,6 +1016,8 @@ static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *v
 							      uint32_t function,
 							      uint32_t index)
 {
+	TEST_ASSERT(vcpu->cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
+
 	return (struct kvm_cpuid_entry2 *)get_cpuid_entry(vcpu->cpuid,
 							  function, index);
 }
-- 
2.47.0.338.g60cca15819-goog


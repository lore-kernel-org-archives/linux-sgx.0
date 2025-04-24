Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B74315C
	for <linux-sgx@vger.kernel.org>; Thu, 24 Apr 2025 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502172; cv=none; b=pjLR4NM+4tv/QQM3nK4QFJoxjJbCLHEEtrLRGqnTn5CsDpF6KUO+bb9vQtWBgbBLQP5afxioAAqrQINzvHSyk/JXS4NTDllv0FIew+vHDc6DrKxX9OmABNrMAFo/qan0KwDRgoydHUstAeriO1N83Oj6z8L7L0KzDiwKcUoQw+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502172; c=relaxed/simple;
	bh=8AU6WBlrfwv9i8IiVDWiGT12d6hTVqeXjO8OAeB06UA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p3IuWvsBI6rBvKXcojpqKASr8JHiDCXr80vAnDygFUm9v074rMVTpKT+1cIQ+xYHgTh9JPPdf52b5s9goaA6VBrp010f+pQBrcyuSUbd3XhEzIjWWTw9bvTGp0RvQAk+n1NnOOfdGFIDBSjWO8EQPSOf8N0IvU4sAXnuaPbJe24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JWPjpKnI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JWPjpKnI"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff64898e2aso1653639a91.1
        for <linux-sgx@vger.kernel.org>; Thu, 24 Apr 2025 06:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745502170; x=1746106970; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U2fF6Wh0fn4eLRWF2k6LYiCI21NvyqxB71AExdVUjHo=;
        b=JWPjpKnIe5pq6cwRG6YXSUeWfuVbjNaapJzMLOB/w/dkocZeUum0raaRyOFJ/6CLnu
         BPOcHisZeG6kWytBPZVxsE64Fz6nTW7MMa7gaOX8Au4LqlC83Uza9pxxWdiaGrbCJ6bZ
         VB2zmNTHz6J47WOCs+Ip7BRicj/zSeKEGk66BZRjEFe91JxWNWku1LqhNxVUypR3HEIM
         4K0s9mczr4PfO3s+PYgr4xcb/Hyj84Ql2DxRf1OHmCXP6nn7GWXLCViMZOY+pr/FLiBG
         9DH9X5QXvdoSFmrBpB4lr02+nQXidmH62Gy6auaZdvd0HVrxu7I/4RevDwYuqRuRZuJi
         nIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745502170; x=1746106970;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U2fF6Wh0fn4eLRWF2k6LYiCI21NvyqxB71AExdVUjHo=;
        b=QGjPJsmBApkb00YztdG8WMjEa14OSebzUydOQWEfvPzSI+fGempEWLHLweLlYjvAQC
         D2je4esqMd3YDHn8uVI4eX7tkbEAICD/7gcW59CBSWWuDLItu3UOvhgNO/QUt1sHnqrT
         b6C5Rtjg3IXMz4KCb/DaXVe0hW+NxMSMMYTLMH4vXy+7Im+6ZjnREI8EwrByVTcW8bup
         NPOLYvvCMN1ufgt4zbbYGvs0pnt8LfECKBbqZucz+b4n9yo5qfkO8fEQKYgmZGp7B72T
         JZ7EDxWOtkxJ7JkCblWtC1To3aR0B8bQnEIfHzqHXowtHbw20vLQBs3Ts4SZvLqT8dtz
         EVVg==
X-Forwarded-Encrypted: i=1; AJvYcCXeVFd9ITeMSheItezN/fr4AoH2mb1+y/MsPDcEQNJIXCWQrc3JckEj1B3ElflsdB1NNncehONBSDc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwfLe1wPJdy3asJQURh6TF3ItuagoxK9Pb02ccYgnjTjhjetlk
	h5zE5Q1GVFS15uIzsfdC1Ilf+HO+Z9O6olCJLzadTCC/isBjHLLRHNv+yre+3JXOssu6mWPLa5w
	zPQ==
X-Google-Smtp-Source: AGHT+IGedxc9J5DHeJSE9G0tqfkTa1UlOm8+kBbsCPW2uqNOUB/tlH2c/Ts0LAuodf0hiT+LMDCf9z19zLQ=
X-Received: from pjbqo4.prod.google.com ([2002:a17:90b:3dc4:b0:2fa:1fac:2695])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc3:b0:2ff:4a8d:74f9
 with SMTP id 98e67ed59e1d1-309ee39aa1dmr3821199a91.10.1745502170041; Thu, 24
 Apr 2025 06:42:50 -0700 (PDT)
Date: Thu, 24 Apr 2025 06:42:48 -0700
In-Reply-To: <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com> <aAJn8tgubjT5t7DB@google.com>
 <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
 <aAefmNVRFc3me6QQ@google.com> <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
Message-ID: <aAo_2MPGOkOciNuM@google.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
From: Sean Christopherson <seanjc@google.com>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
	Vincent R Scarlata <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, Vishal Annapurve <vannapurve@google.com>, Chong Cai <chongc@google.com>, 
	Asit K Mallick <asit.k.mallick@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>, 
	"dionnaglaze@google.com" <dionnaglaze@google.com>, Scott Raynor <scott.raynor@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2025, Elena Reshetova wrote:
> > On Tue, Apr 22, 2025, Kai Huang wrote:
> > > On Fri, 2025-04-18 at 07:55 -0700, Sean Christopherson wrote:
> > > > On Tue, Apr 15, 2025, Elena Reshetova wrote:
> > > > That said, handling this deep in the bowels of EPC page allocation =
seems
> > > > unnecessary.  The only way for there to be no active EPC pages is i=
f
> > > > there are no enclaves.  As above, virtual EPC usage is already all =
but
> > > > guaranteed to hit false positives, so I don't think there's anythin=
g
> > > > gained by trying to update the SVN based on EPC allocations.
> > > >
> > > > So rather than react to EPC allocations, why not hook sgx_open() an=
d
> > sgx_vepc_open()?
> > >
> > > The only thing I don't like about this is we need to hook both of the=
m.
> >=20
> > And having to maintain a separate counter.

...

> If we follow the approach of trying to execute EUPDATESVN via=20
> sgx_open() and sgx_vepc_open() paths, it adds more complexity to kernel
> code=20

This is where I disagree.  I don't see how it's more complex even on the su=
rface,
and when you start considering the implications of "randomly" inserting a n=
on-
trivial operation into EPC allocation, IMO it's far less complex overall.

> and imo it still doesn=E2=80=99t remove the complexity from userspace
> orchestration sw. I.e. userspace still has to get rid of host enclaves an=
d=20
> SGX enabled VMs (because syncing with VMs owners to make sure their
> encalves are destroyed and these VMs are ready for EUDPATESVN seems
> like a big organizational complexity and error prone).

Yeah, I don't see a way around that.

> So, the only thing this approach would address would be an EPC
> pre-allocation done by qemu? Wouldn't it be more reasonable
> (here I am purely speculating, I dont know qemu code) to implement
> in qemu the code to drop EPC pre-allocation if no VMs with SGX are
> running? That would be a good overall policy imo not to waste EPC
> space when not needed in practice.=20

QEMU only preallocates when the VM is being created, i.e. QEMU doesn't main=
tain
a persistent pool.  All I was saying is that userspace needs to shut down S=
GX
capable VMs, even if the VM isn't actively running enclaves, which is a sha=
me.

Untested sketch of hooking create/delete to do SVN updates.

---
 arch/x86/kernel/cpu/sgx/driver.c |  4 ++++
 arch/x86/kernel/cpu/sgx/encl.c   |  2 ++
 arch/x86/kernel/cpu/sgx/main.c   | 34 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
 arch/x86/kernel/cpu/sgx/virt.c   |  6 ++++++
 5 files changed, 49 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/dri=
ver.c
index 7f8d1e11dbee..669e44d61f9f 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -19,6 +19,10 @@ static int sgx_open(struct inode *inode, struct file *fi=
le)
 	struct sgx_encl *encl;
 	int ret;
=20
+	ret =3D sgx_inc_usage_count();
+	if (ret)
+		return ret;
+
 	encl =3D kzalloc(sizeof(*encl), GFP_KERNEL);
 	if (!encl)
 		return -ENOMEM;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.=
c
index 279148e72459..84ca78627e55 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -765,6 +765,8 @@ void sgx_encl_release(struct kref *ref)
 	WARN_ON_ONCE(encl->secs.epc_page);
=20
 	kfree(encl);
+
+	sgx_dec_usage_count();
 }
=20
 /*
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.=
c
index 8ce352fc72ac..ca74c91d4291 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -914,6 +914,40 @@ int sgx_set_attribute(unsigned long *allowed_attribute=
s,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
=20
+static atomic_t sgx_usage_count;
+static DEFINE_MUTEX(sgx_svn_lock);
+
+static int sgx_update_svn(void)
+{
+	// blah blah blah
+}
+
+int sgx_inc_usage_count(void)
+{
+	if (atomic_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	guard(mutex)(&sgx_svn_lock);
+
+	if (atomic_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	return sgx_update_svn();
+}
+
+void sgx_dec_usage_count(void)
+{
+	if (atomic_dec_return(&sgx_usage_count))
+		return;
+
+	guard(mutex)(&sgx_svn_lock);
+
+	if (atomic_read(&sgx_usage_count))
+		return;
+
+	sgx_update_svn();
+}
+
 static int __init sgx_init(void)
 {
 	int ret;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..f5940393d9bd 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -102,6 +102,9 @@ static inline int __init sgx_vepc_init(void)
 }
 #endif
=20
+int sgx_inc_usage_count(void);
+void sgx_dec_usage_count(void);
+
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
=20
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.=
c
index 7aaa3652e31d..e548de340c2e 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,12 +255,18 @@ static int sgx_vepc_release(struct inode *inode, stru=
ct file *file)
 	xa_destroy(&vepc->page_array);
 	kfree(vepc);
=20
+	sgx_dec_usage_count();
 	return 0;
 }
=20
 static int sgx_vepc_open(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc;
+	int ret;
+
+	ret =3D sgx_inc_usage_count();
+	if (ret)
+		return ret;
=20
 	vepc =3D kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
 	if (!vepc)

base-commit: 37374f38f6c5291ae66ce05f9435c3b519b6f234
--=20


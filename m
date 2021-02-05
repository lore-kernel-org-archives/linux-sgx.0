Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4F0C433E6
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 19:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9013E64FA7
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 19:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBER5t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Feb 2021 12:57:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:32227 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbhBERzQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Feb 2021 12:55:16 -0500
IronPort-SDR: xb0O8Yd1UhAxN9qVhZ8+JMZWm9YZphtTeyt5+1GNoIQ72G2cSSPSGJQ8AutCYKEOY/Qyr96nFV
 uUjB4cjwBi5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="181543892"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="181543892"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 11:36:58 -0800
IronPort-SDR: Z3JIA+i3JSl2/K+KkBh1IFLkm0sJOn06pShD9CiAogQqBFVESZtE3IXnlnXxcEtnd85X1eh3jc
 YW37RCXUzXEg==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434577302"
Received: from arwatson-mobl1.amr.corp.intel.com (HELO [10.212.10.204]) ([10.212.10.204])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 11:36:58 -0800
Subject: Re: [PATCH 2/2] x86/sgx: Maintain encl->refcount for each
 encl->mm_list entry
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
References: <20210205182840.2260-1-jarkko@kernel.org>
 <20210205182840.2260-2-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <b874673d-9d58-0d6f-ce2d-ef4d33ac5115@intel.com>
Date:   Fri, 5 Feb 2021 11:36:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210205182840.2260-2-jarkko@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------AD3EC73A5ABF674974E52A08"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This is a multi-part message in MIME format.
--------------AD3EC73A5ABF674974E52A08
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2/5/21 10:28 AM, Jarkko Sakkinen wrote:
> This has been shown in tests:
> 
> [  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 cleanup_srcu_struct+0xed/0x100
> 
> There are two functions that drain encl->mm_list:
> 
> - sgx_release() (i.e. VFS release) removes the remaining mm_list entries.
> - sgx_mmu_notifier_release() removes mm_list entry for the registered
>   process, if it still exists.

Jarkko, I like your approach.  This actually has the potential to be a
lot more understandable than the fix we settled on before.

But I think the explanation needs some tweaking, and I think I can take
it a step further to make it even more straightforward.  The issue here
isn't *really* mm_list, it's this:

	encl_mm->encl = encl;

That literally establishes a encl_mm to encl reference and needs a
reference count.  That reference remains until 'encl_mm' is freed.  I
don't think mm_list needs to even be taken into account.

The most straightforward way to fix this is to take a refcount at
"encl_mm->encl = encl" and release it at kfree(encl_mm).  That makes a
*lot* of logical sense to me, and it's also trivial to audit.

Totally untested patch attached (adapted directly from yours).

--------------AD3EC73A5ABF674974E52A08
Content-Type: text/x-patch; charset=UTF-8;
 name="raw.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="raw.patch"



This has been shown in tests:

[  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 clea=
nup_srcu_struct+0xed/0x100

This is essentially a use-after free, although SRCU notices it as
an SRCU cleanup in an invalid context.

=3D=3D Background =3D=3D

SGX has a data structure (struct sgx_encl_mm) which keeps per-mm SGX
metadata.  This is separate from 'struct sgx_encl' because, in theory,
an enclave can be mapped from more than one mm.  sgx_encl_mm includes
a pointer back to the sgx_encl.

This means that sgx_encl must have a longer lifetime than all of the
sgx_encl_mm's that point to it.  That's usually the case: sgx_encl_mm
is freed only after the mmu_notifier is unregistered in sgx_release().

However, there's a race.  If the process is exiting,
sgx_mmu_notifier_release() can be called in parallel with sgx_release()
instead of being called *by* it.  The mmu_notifier path keeps encl_mm
alive past when sgx_encl can be freed.  This inverts the lifetime rules
and means that sgx_mmu_notifier_release() can access a freed sgx_encl.

=3D=3D Fix =3D=3D

Increase encl->refcount when encl_mm->encl is established. Release
this reference encl_mm is freed.  This ensures that 'encl' outlives
'encl_mm'.


Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Cc: Dave Hansen <dave.hansen@linux.intel.com
Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

 b/arch/x86/kernel/cpu/sgx/driver.c |    3 +++
 b/arch/x86/kernel/cpu/sgx/encl.c   |    5 +++++
 2 files changed, 8 insertions(+)

diff -puN arch/x86/kernel/cpu/sgx/driver.c~raw arch/x86/kernel/cpu/sgx/dr=
iver.c
--- a/arch/x86/kernel/cpu/sgx/driver.c~raw	2021-02-05 10:52:47.484545869 =
-0800
+++ b/arch/x86/kernel/cpu/sgx/driver.c	2021-02-05 10:59:06.497544923 -080=
0
@@ -72,6 +72,9 @@ static int sgx_release(struct inode *ino
 		synchronize_srcu(&encl->srcu);
 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
 		kfree(encl_mm);
+
+		/* 'encl_mm' is gone, put encl_mm->encl reference: */
+		kref_put(&encl->refcount, sgx_encl_release);
 	}
=20
 	kref_put(&encl->refcount, sgx_encl_release);
diff -puN arch/x86/kernel/cpu/sgx/encl.c~raw arch/x86/kernel/cpu/sgx/encl=
=2Ec
--- a/arch/x86/kernel/cpu/sgx/encl.c~raw	2021-02-05 10:52:47.486545869 -0=
800
+++ b/arch/x86/kernel/cpu/sgx/encl.c	2021-02-05 11:23:06.674541332 -0800
@@ -481,6 +481,9 @@ static void sgx_mmu_notifier_free(struct
 {
 	struct sgx_encl_mm *encl_mm =3D container_of(mn, struct sgx_encl_mm, mm=
u_notifier);
=20
+	/* 'encl_mm' is goin away, put encl_mm->encl reference: */
+	kref_put(&encl_mm->encl->refcount, sgx_encl_release);
+
 	kfree(encl_mm);
 }
=20
@@ -534,6 +537,8 @@ int sgx_encl_mm_add(struct sgx_encl *enc
 	if (!encl_mm)
 		return -ENOMEM;
=20
+	/* Grab a refcount for the encl_mm->encl reference: */
+	kref_get(&encl->refcount);
 	encl_mm->encl =3D encl;
 	encl_mm->mm =3D mm;
 	encl_mm->mmu_notifier.ops =3D &sgx_mmu_notifier_ops;
_

--------------AD3EC73A5ABF674974E52A08--

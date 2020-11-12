Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FB6C2D0E4
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 20:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54548216FD
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 20:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgKLU7L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 15:59:11 -0500
Received: from wind.enjellic.com ([76.10.64.91]:60382 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgKLU7K (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 15:59:10 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0ACKwLc3009502;
        Thu, 12 Nov 2020 14:58:21 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0ACKwJdN009501;
        Thu, 12 Nov 2020 14:58:19 -0600
Date:   Thu, 12 Nov 2020 14:58:19 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Message-ID: <20201112205819.GA9172@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com> <20201106174359.GA24109@wind.enjellic.com> <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com> <20201107150930.GA29530@wind.enjellic.com> <c7157bc6-8a65-11f4-e961-17163730df5d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7157bc6-8a65-11f4-e961-17163730df5d@intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 12 Nov 2020 14:58:21 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 07, 2020 at 11:16:25AM -0800, Dave Hansen wrote:

Good afternoon, I hope the week is going well for everyone.

> On 11/7/20 7:09 AM, Dr. Greg wrote:
> > In all of these discussions there hasn't been a refutation of my point
> > that the only reason this hook is needed is to stop the potential for
> > anonymous code execution on SGX2 capable hardware.  So we will assume,
> > that while unspoken, this is the rationale for the hook.

> Unspoken?  See from the cover letter:

The complexity of the issues involved and the almost complete lack of
understanding of the technology in the Linux user community would
suggest that everyone would benefit from a more detailed explanation
of the issues at hand.

> > 3. Enclave page permissions are dynamic (just like normal permissions) and
> >    can be adjusted at runtime with mprotect().

> I explicitly chose not to name the instructions, nor the exact
> version of the SGX ISA that introduces them.  They're supported in
> the series, and that's all that matters.

When it comes to security issues and risk assessment it always seems
that more information is better, but of course opinions vary, wildly
it would seem in the case of this technology.

I've been told countless times in my career: "What happens if you get
hit by a bus".  I've tried to address those issues by generating
copious amounts of documentation on everything I do.  Having the
relevant issues with respect to the security considerations and
implications of this technology clearly documented would seem to
address the 'hit by a bus' issue for other developers that may need to
look at and understand the code down the road.

> If you want to advocate for something different to be done, patches
> are accepted.

I'm including a patch below that addresses the mprotect vulnerability
as simplistically as I believe it can be addressed and provides some
background information on the issues at hand.  I will let people more
wise then I am decide whether or not the world at large is worse off
for having the information available.

I tested this with our runtime, which is of a significantly different
design then Intel's.  After testing multiple adversarial approaches to
changing page permissions, I'm left struggling to understand what the
page walking code accomplishes, even in the case of mmap.

The ultimate decision with respect to allowed page permissions is
cryptographically encoded in the enclave measurement.  The enclave
won't initialize if changes are made to the desired EPCM permissions.
If an attempt is made to use mmap to alter those permissions at the OS
level they will be inhibited by the EPCM permission verifications.

If one reads the EDMM papers by the Intel engineering team that
designed the technology, they were very concerned about an enclave
having to agree to any virtual memory changes, hence the need for
ENCLU[EACCEPT] and ENCLU[EACCEPTCOPY].  In that respect the behavior
of ENCLU[EMODPE] is somewhat interesting in that it gives untrusted
userspace the ability to thwart the intentions of enclave code.

They may not, however, have had any other choice given that SGX was
designed as a virtual memory play in order to make it an 'easy'
add-on.

Given all of this, it seems to be the case that the only thing needed
to block anonymous code execution is to block mprotect on an
initialized enclave, which the attached patch does.  If and when the
driver supports EDMM there is, I believe, a very open question as to
what type of introspection capability the kernel should have.

More on that in a subsequent post/patch.

Have a good evening.

Dr. Greg

Cut here. -----------------------------------------------------------------
From 68cba86b0cb3c5917e8c42d83edd5220e2890bb1 Mon Sep 17 00:00:00 2001
From: "Dr. Greg" <greg@enjellic.com>
Date: Thu, 12 Nov 2020 04:48:57 -0600
Subject: [PATCH] Unconditionally block mprotect of enclave memory.

In SGX there are two levels of memory protection, the classic
page table mechanism and SGX hardware based page protections
that are codified in the Enclave Page Cache Metadata.  A
successful memory access requires that both mechanisms agree
that the access is permitted.

In the initial implementation of SGX (SGX1), the page permissions
are immutable after the enclave is initialized.  Even if classic
page protections are modified via mprotect, any attempt to access
enclave memory with alternative permissions will be blocked.

One of the architectural changes implemented in the second
generation of SGX (SGX2) is the ability for page access
permissions to be dynamically manipulated after the enclave is
initialized.  This requires coordination between trusted code
running in the enclave and untrusted code using mprotect and
special ring-0 instructions.

One of the security threats associated with SGX2 hardware is that
enclave based code can conspire with its untrusted runtime to make
executable enclave memory writable.  This provides the opportunity for
completely anonymous code execution that the operating system has no
visibility into.

All that is needed to, simply, close this vulnerability is to
eliminate the ability to call mprotect against the virtual memory
range of an enclave after it is initialized.  Any mprotect changes
made prior to initialization that are inconsistent with the
permissions codified in the enclave will cause initialization and/or
access to fail.

Tested-by: Dr. Greg <greg@enjellic.com>
Signed-off-by: Dr. Greg <greg@enjellic.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 139f8c398685..c613482ebb56 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -270,11 +270,10 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma,
 			    struct vm_area_struct **pprev, unsigned long start,
 			    unsigned long end, unsigned long newflags)
 {
-	int ret;
+	struct sgx_encl *encl = vma->vm_private_data;
 
-	ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
-	if (ret)
-		return ret;
+	if ( test_bit(SGX_ENCL_INITIALIZED, &encl->flags) )
+		return -EACCES;
 
 	return mprotect_fixup(vma, pprev, start, end, newflags);
 }
-- 
2.19.2


And here (demonstrating my age). ------------------------------------------

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Umm.. the developers behind Flame were able to hijack Windows update,
 gain access to a Microsoft code signing and website signing key while
 staying undetected in the wild for at least 2+ years.

 But System Restore 2.0 is going to stop them?  Your average piece of
 malware can survive a system restore..."
                                -- Slashdot

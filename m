Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D79C61DD8
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Nov 2020 17:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF5922284
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Nov 2020 17:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgKORJw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 15 Nov 2020 12:09:52 -0500
Received: from wind.enjellic.com ([76.10.64.91]:60638 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgKORJu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 15 Nov 2020 12:09:50 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0AFH8th8026305;
        Sun, 15 Nov 2020 11:08:55 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0AFH8r4s026304;
        Sun, 15 Nov 2020 11:08:53 -0600
Date:   Sun, 15 Nov 2020 11:08:53 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v41 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Message-ID: <20201115170853.GA26176@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201112220135.165028-1-jarkko@kernel.org> <20201112220135.165028-11-jarkko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112220135.165028-11-jarkko@kernel.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 15 Nov 2020 11:08:55 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 13, 2020 at 12:01:21AM +0200, Jarkko Sakkinen wrote:

Good morning, I hope the weekend is going well for everyone.

> From: Sean Christopherson <sean.j.christopherson@intel.com>

We wish Sean well in whatever new avocation he has chosen.

> Background
> ==========
> 
> 1. SGX enclave pages are populated with data by copying from normal memory
>    via ioctl() (SGX_IOC_ENCLAVE_ADD_PAGES), which will be added later in
>    this series.
> 2. It is desirable to be able to restrict those normal memory data sources.
>    For instance, to ensure that the source data is executable before
>    copying data to an executable enclave page.
> 3. Enclave page permissions are dynamic (just like normal permissions) and
>    can be adjusted at runtime with mprotect().
>
> This creates a problem because the original data source may have long since
> vanished at the time when enclave page permissions are established (mmap()
> or mprotect()).
> 
> The solution (elsewhere in this series) is to force enclaves creators to
> declare their paging permission *intent* up front to the ioctl().  This
> intent can be immediately compared to the source data???s mapping and
> rejected if necessary.
> 
> The ???intent??? is also stashed off for later comparison with enclave
> PTEs. This ensures that any future mmap()/mprotect() operations
> performed by the enclave creator or done on behalf of the enclave
> can be compared with the earlier declared permissions.

The new mprotect hook in vm_operations_struct is indeed useful, as I
will demonstrate in a subsequent patch for consideration.  However,
the officially stated intent of this version of the driver is to
implement SGX1 semantics even on hardware (SGX2) that implements the
instructions needed for Enclave Dynamic Memory Management (EDMM).

As a result, at this stage of the driver's development, the
implementation that walks the page permission intents can be
substituted with a simple denial of mmap and mprotect on an
initialized enclave.  With this prohibition in place, the hardware
itself will enforce the page permission intents that were encoded when
the enclave was loaded, thus making the subsequent scan irrelevant.

The following patch implements this functionality.

Dr. Greg

---------------------------------------------------------------------------
Subject: [PATCH] Unconditionally block permission changes on enclave memory.

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
eliminate the ability to call mprotect or mmap against the virtual
memory range of an enclave after it is initialized.  Any
permission changes made prior to initialization that are inconsistent
with the permissions codified in the enclave will cause initialization
or execution of the enclave to fail.

Tested-by: Dr. Greg <greg@enjellic.com>
Signed-off-by: Dr. Greg <greg@enjellic.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 50 +++++++++-------------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 5551c7d36483..3bd770fbfc32 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -212,27 +212,25 @@ static void sgx_vma_open(struct vm_area_struct *vma)
  * @end:		upper bound of the address range, exclusive
  * @vm_flags:		VMA flags
  *
- * Iterate through the enclave pages contained within [@start, @end) to verify
- * that the permissions requested by a subset of {VM_READ, VM_WRITE, VM_EXEC}
- * does not contain any permissions that are not contained in the build time
- * permissions of any of the enclave pages within the given address range.
+ * This function provides a method for determining whether or not mmap
+ * or mprotect can be invoked called on any pages in the virtual
+ * address range of an enclave.
  *
- * An enclave creator must declare the strongest permissions that will be
- * needed for each enclave page  This ensures that mappings  have the identical
- * or weaker permissions that the earlier declared permissions.
+ * Since this driver is not designed to support Enclave Dynamic Memory
+ * Management (EDMM), any attempts to modify enclave memory map after
+ * the enclave is initialized are simply blocked.
+ *
+ * The function signature is left intact since future versions of the
+ * driver may implement verifications that the requested permission
+ * changes are consistent with the desire of the enclave author.
  *
  * Return: 0 on success, -EACCES otherwise
  */
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 		     unsigned long end, unsigned long vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
-	struct sgx_encl_page *page;
-	unsigned long count = 0;
 	int ret = 0;
 
-	XA_STATE(xas, &encl->page_array, PFN_DOWN(start));
-
 	/*
 	 * Disallow READ_IMPLIES_EXEC tasks as their VMA permissions might
 	 * conflict with the enclave page permissions.
@@ -240,31 +238,9 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 	if (current->personality & READ_IMPLIES_EXEC)
 		return -EACCES;
 
-	mutex_lock(&encl->lock);
-	xas_lock(&xas);
-	xas_for_each(&xas, page, PFN_DOWN(end - 1)) {
-		if (!page)
-			break;
-
-		if (~page->vm_max_prot_bits & vm_prot_bits) {
-			ret = -EACCES;
-			break;
-		}
-
-		/* Reschedule on every XA_CHECK_SCHED iteration. */
-		if (!(++count % XA_CHECK_SCHED)) {
-			xas_pause(&xas);
-			xas_unlock(&xas);
-			mutex_unlock(&encl->lock);
-
-			cond_resched();
-
-			mutex_lock(&encl->lock);
-			xas_lock(&xas);
-		}
-	}
-	xas_unlock(&xas);
-	mutex_unlock(&encl->lock);
+	/* Disallow mapping on an initialized enclave. */
+	if (test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
+		ret = -EACCES;
 
 	return ret;
 }
-- 
2.19.2

---------------------------------------------------------------------------

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: dg@enjellic.com
------------------------------------------------------------------------------
"For a successful technology, reality must take precedence over public
 relations, for nature cannot be fooled."
                                -- Richard Feynmann

Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A86DC31E49
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B80D2084D
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfFMQvc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:51:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:43130 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393028AbfFMQvb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 12:51:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 09:51:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 13 Jun 2019 09:51:30 -0700
Date:   Thu, 13 Jun 2019 09:51:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
Message-ID: <20190613165130.GB5850@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-5-sean.j.christopherson@intel.com>
 <f2e88e83-e5f6-fecb-c180-b75be1d1a582@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2e88e83-e5f6-fecb-c180-b75be1d1a582@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 12:43:42AM +0000, Jethro Beekman wrote:
> On 2019-06-05 12:48, Sean Christopherson wrote:
> >...to improve performance when building enclaves by reducing the number
> >of user<->system transitions.  Rather than provide arbitrary batching,
> >e.g. with per-page SECINFO and mrmask, take advantage of the fact that
> >any sane enclave will have large swaths of pages with identical
> >properties, e.g. code vs. data sections.
> >
> >For simplicity and stability in the initial implementation, loop over
> >the existing add page flow instead of taking a more agressive approach,
> >which would require tracking transitions between VMAs and holding
> >mmap_sem for an extended duration.
> >
> >On an error, update the userspace struct to reflect progress made, e.g.
> >so that the ioctl can be re-invoked to finish adding pages after a non-
> >fatal error.
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  Documentation/x86/sgx/3.API.rst        |   2 +-
> >  arch/x86/include/uapi/asm/sgx.h        |  21 ++--
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 128 +++++++++++++++++--------
> >  3 files changed, 98 insertions(+), 53 deletions(-)
> >
> >diff --git a/Documentation/x86/sgx/3.API.rst b/Documentation/x86/sgx/3.API.rst
> >index b113aeb05f54..44550aa41073 100644
> >--- a/Documentation/x86/sgx/3.API.rst
> >+++ b/Documentation/x86/sgx/3.API.rst
> >@@ -22,6 +22,6 @@ controls the `PROVISON_KEY` attribute.
> >  .. kernel-doc:: arch/x86/kernel/cpu/sgx/driver/ioctl.c
> >     :functions: sgx_ioc_enclave_create
> >-               sgx_ioc_enclave_add_page
> >+               sgx_ioc_enclave_add_region
> >                 sgx_ioc_enclave_init
> >                 sgx_ioc_enclave_set_attribute
> >diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> >index 9ed690a38c70..30d114f6b3bd 100644
> >--- a/arch/x86/include/uapi/asm/sgx.h
> >+++ b/arch/x86/include/uapi/asm/sgx.h
> >@@ -12,8 +12,8 @@
> >  #define SGX_IOC_ENCLAVE_CREATE \
> >  	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> >-#define SGX_IOC_ENCLAVE_ADD_PAGE \
> >-	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> >+#define SGX_IOC_ENCLAVE_ADD_REGION \
> >+	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_region)
> >  #define SGX_IOC_ENCLAVE_INIT \
> >  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> >  #define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> >@@ -32,21 +32,22 @@ struct sgx_enclave_create  {
> >  };
> >  /**
> >- * struct sgx_enclave_add_page - parameter structure for the
> >- *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> >- * @addr:	address within the ELRANGE
> >- * @src:	address for the page data
> >- * @secinfo:	address for the SECINFO data
> >- * @mrmask:	bitmask for the measured 256 byte chunks
> >+ * struct sgx_enclave_add_region - parameter structure for the
> >+ *                                 %SGX_IOC_ENCLAVE_ADD_REGION ioctl
> >+ * @addr:	start address within the ELRANGE
> >+ * @src:	start address for the pages' data
> >+ * @size:	size of region, in bytes
> >+ * @secinfo:	address of the SECINFO data (common to the entire region)
> >+ * @mrmask:	bitmask of 256 byte chunks to measure (applied per 4k page)
> >   */
> >-struct sgx_enclave_add_page {
> >+struct sgx_enclave_add_region {
> >  	__u64	addr;
> >  	__u64	src;
> >+	__u64	size;
> >  	__u64	secinfo;
> >  	__u16	mrmask;
> 
> Considering:
> 
> 1. I might want to load multiple pages that are not consecutive in memory.
> 2. Repeating mrmask (other than 0 or ~0) doesn't really make sense for
> ranges.
> 
> I'd be in favor of an approach that passes an array of sgx_enclave_add_page
> instead.

I'm not opposed to taking an array.  The region approach seemed simpler
at first glance, but that may not be the case, especially if we get rid of
the workqueue.  I'll play around with it.

> Somewhat unrelated: have you considered optionally "gifting" enclave source
> pages to the kernel (as in vmsplice)? That would avoid the copy_from_user.

If we ditch the workqueue then we probably don't even need to gift the
page, e.g. I think we allocate the EPC page prior to taking mmap_sem, and
then simply do gup+kmap around EADD.  We'd just need to be careful about
not allocating EPC pages for ioctls that are guaranteed to fail.



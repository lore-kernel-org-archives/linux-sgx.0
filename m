Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11632C31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 19:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE7D20B7C
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 19:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560452752;
	bh=VJF6P0keKxjnL7eBJs7EqWGcoifLH05mVndo/4v+fFQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ovXMrqrr/hwElnsYSx3ZzNaUKSOtCWKhZ6RlsSKHrFP+AJlILe1sPGpz/rs/TIsuW
	 0MypvxCpVLpx0bfEWtzv9XMewubtaUlChR9HEFPOmWoqHC/6hogAssHdfX2acnZWq0
	 yGbXMlHRNFzXrr687Uu+RLI39l/dtfVFt9rG8yY0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfFMTFv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 15:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfFMTFv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 15:05:51 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 614FC20B7C
        for <linux-sgx@vger.kernel.org>; Thu, 13 Jun 2019 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560452750;
        bh=VJF6P0keKxjnL7eBJs7EqWGcoifLH05mVndo/4v+fFQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LZgDLhsuXWAwDKr5FAa2SQoYgk3c/q5cRc8s9vmmjRd0M3bTfyCmaBuzbotgAMZEH
         ahueso7KAhiGu/C/3WWaCimD7R6aaenGNX0lbp4I2wCRzuMOXnrjP2jAptbtxRav5H
         1gqn/Nu3TllinFIwbNp1TASSXx20wADffFpoFjzs=
Received: by mail-wr1-f46.google.com with SMTP id n4so21892077wrw.13
        for <linux-sgx@vger.kernel.org>; Thu, 13 Jun 2019 12:05:50 -0700 (PDT)
X-Gm-Message-State: APjAAAU5aTOu0U94I73QvKX1h6xjXUWhR+FCaZ35olhYGiihvbHLrMOF
        +mkpoBat50v0L+I1/SqW6e0FKVykJtd91gsNHQ3iNg==
X-Google-Smtp-Source: APXvYqx58lRL7Dw1JsHhof6ox8Ijbuvpt/1mcPhK8q6caTLlmjaWh9KvdWoC/6I1l3fUbJa020L2NUL++JPZ4gslhMM=
X-Received: by 2002:a5d:6207:: with SMTP id y7mr40570485wru.265.1560452748955;
 Thu, 13 Jun 2019 12:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-5-sean.j.christopherson@intel.com> <f2e88e83-e5f6-fecb-c180-b75be1d1a582@fortanix.com>
 <20190613165130.GB5850@linux.intel.com>
In-Reply-To: <20190613165130.GB5850@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 13 Jun 2019 12:05:37 -0700
X-Gmail-Original-Message-ID: <CALCETrU8ZNL==n+fC2aH7437cstq68Xu8LJnQFnOFGCWc1L3OQ@mail.gmail.com>
Message-ID: <CALCETrU8ZNL==n+fC2aH7437cstq68Xu8LJnQFnOFGCWc1L3OQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 9:51 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Jun 13, 2019 at 12:43:42AM +0000, Jethro Beekman wrote:
> > On 2019-06-05 12:48, Sean Christopherson wrote:
> > >...to improve performance when building enclaves by reducing the number
> > >of user<->system transitions.  Rather than provide arbitrary batching,
> > >e.g. with per-page SECINFO and mrmask, take advantage of the fact that
> > >any sane enclave will have large swaths of pages with identical
> > >properties, e.g. code vs. data sections.
> > >
> > >For simplicity and stability in the initial implementation, loop over
> > >the existing add page flow instead of taking a more agressive approach,
> > >which would require tracking transitions between VMAs and holding
> > >mmap_sem for an extended duration.
> > >
> > >On an error, update the userspace struct to reflect progress made, e.g.
> > >so that the ioctl can be re-invoked to finish adding pages after a non-
> > >fatal error.
> > >
> > >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > >---
> > >  Documentation/x86/sgx/3.API.rst        |   2 +-
> > >  arch/x86/include/uapi/asm/sgx.h        |  21 ++--
> > >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 128 +++++++++++++++++--------
> > >  3 files changed, 98 insertions(+), 53 deletions(-)
> > >
> > >diff --git a/Documentation/x86/sgx/3.API.rst b/Documentation/x86/sgx/3.API.rst
> > >index b113aeb05f54..44550aa41073 100644
> > >--- a/Documentation/x86/sgx/3.API.rst
> > >+++ b/Documentation/x86/sgx/3.API.rst
> > >@@ -22,6 +22,6 @@ controls the `PROVISON_KEY` attribute.
> > >  .. kernel-doc:: arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > >     :functions: sgx_ioc_enclave_create
> > >-               sgx_ioc_enclave_add_page
> > >+               sgx_ioc_enclave_add_region
> > >                 sgx_ioc_enclave_init
> > >                 sgx_ioc_enclave_set_attribute
> > >diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > >index 9ed690a38c70..30d114f6b3bd 100644
> > >--- a/arch/x86/include/uapi/asm/sgx.h
> > >+++ b/arch/x86/include/uapi/asm/sgx.h
> > >@@ -12,8 +12,8 @@
> > >  #define SGX_IOC_ENCLAVE_CREATE \
> > >     _IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> > >-#define SGX_IOC_ENCLAVE_ADD_PAGE \
> > >-    _IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> > >+#define SGX_IOC_ENCLAVE_ADD_REGION \
> > >+    _IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_region)
> > >  #define SGX_IOC_ENCLAVE_INIT \
> > >     _IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> > >  #define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> > >@@ -32,21 +32,22 @@ struct sgx_enclave_create  {
> > >  };
> > >  /**
> > >- * struct sgx_enclave_add_page - parameter structure for the
> > >- *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> > >- * @addr:   address within the ELRANGE
> > >- * @src:    address for the page data
> > >- * @secinfo:        address for the SECINFO data
> > >- * @mrmask: bitmask for the measured 256 byte chunks
> > >+ * struct sgx_enclave_add_region - parameter structure for the
> > >+ *                                 %SGX_IOC_ENCLAVE_ADD_REGION ioctl
> > >+ * @addr:   start address within the ELRANGE
> > >+ * @src:    start address for the pages' data
> > >+ * @size:   size of region, in bytes
> > >+ * @secinfo:        address of the SECINFO data (common to the entire region)
> > >+ * @mrmask: bitmask of 256 byte chunks to measure (applied per 4k page)
> > >   */
> > >-struct sgx_enclave_add_page {
> > >+struct sgx_enclave_add_region {
> > >     __u64   addr;
> > >     __u64   src;
> > >+    __u64   size;
> > >     __u64   secinfo;
> > >     __u16   mrmask;
> >
> > Considering:
> >
> > 1. I might want to load multiple pages that are not consecutive in memory.
> > 2. Repeating mrmask (other than 0 or ~0) doesn't really make sense for
> > ranges.
> >
> > I'd be in favor of an approach that passes an array of sgx_enclave_add_page
> > instead.
>
> I'm not opposed to taking an array.  The region approach seemed simpler
> at first glance, but that may not be the case, especially if we get rid of
> the workqueue.  I'll play around with it.
>
> > Somewhat unrelated: have you considered optionally "gifting" enclave source
> > pages to the kernel (as in vmsplice)? That would avoid the copy_from_user.
>
> If we ditch the workqueue then we probably don't even need to gift the
> page, e.g. I think we allocate the EPC page prior to taking mmap_sem, and
> then simply do gup+kmap around EADD.  We'd just need to be careful about
> not allocating EPC pages for ioctls that are guaranteed to fail.
>
>

Why gup + kmap?  Can't you just do STAC; EADD; CLAC?  (Using the
appropriate C helpers, of course.)

--Andy

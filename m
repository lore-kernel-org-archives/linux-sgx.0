Return-Path: <SRS0=CuW6=XW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF82C4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 17:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75A8A21924
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 17:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfI0RUO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Sep 2019 13:20:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:44174 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0RUO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Sep 2019 13:20:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 10:20:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,556,1559545200"; 
   d="scan'208";a="184051043"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2019 10:20:12 -0700
Date:   Fri, 27 Sep 2019 10:20:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 05/24] x86/sgx: Add ENCLS architectural error codes
Message-ID: <20190927172012.GE25513@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-6-jarkko.sakkinen@linux.intel.com>
 <20190927102013.GA23002@zn.tnic>
 <20190927160842.GL10545@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927160842.GL10545@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 27, 2019 at 07:08:42PM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 27, 2019 at 12:20:13PM +0200, Borislav Petkov wrote:
> > On Tue, Sep 03, 2019 at 05:26:36PM +0300, Jarkko Sakkinen wrote:
> > > Document ENCLS architectural error codes. These error codes are returned by
> > > the SGX opcodes. Make the header as part of the uapi so that they can be
> > > used in some situations directly returned to the user space (ENCLS[EINIT]
> > > leaf function error codes could be one potential use case).
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/include/uapi/asm/sgx_errno.h | 91 +++++++++++++++++++++++++++
> > >  1 file changed, 91 insertions(+)
> > >  create mode 100644 arch/x86/include/uapi/asm/sgx_errno.h
> > > 
> > > diff --git a/arch/x86/include/uapi/asm/sgx_errno.h b/arch/x86/include/uapi/asm/sgx_errno.h
> > > new file mode 100644
> > > index 000000000000..48b87aed58d7
> > > --- /dev/null
> > > +++ b/arch/x86/include/uapi/asm/sgx_errno.h
> > > @@ -0,0 +1,91 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> > > +/*
> > > + * Copyright(c) 2018 Intel Corporation.
> > > + *
> > > + * Contains the architecturally defined error codes that are returned by SGX
> > > + * instructions, e.g. ENCLS, and may be propagated to userspace via errno.
> > > + */
> > > +
> > > +#ifndef _UAPI_ASM_X86_SGX_ERRNO_H
> > > +#define _UAPI_ASM_X86_SGX_ERRNO_H
> > > +
> > > +/**
> > > + * enum sgx_encls_leaves - return codes for ENCLS, ENCLU and ENCLV
> > > + * %SGX_SUCCESS:		No error.
> > > + * %SGX_INVALID_SIG_STRUCT:	SIGSTRUCT contains an invalid value.
> > > + * %SGX_INVALID_ATTRIBUTE:	Enclave is not attempting to access a resource
> > 
> > That first "not" looks wrong.
> > 
> > > + *				for which it is not authorized.
> > > + * %SGX_BLKSTATE:		EPC page is already blocked.
> > > + * %SGX_INVALID_MEASUREMENT:	SIGSTRUCT or EINITTOKEN contains an incorrect
> > > + *				measurement.
> > > + * %SGX_NOTBLOCKABLE:		EPC page type is not one which can be blocked.
> > > + * %SGX_PG_INVLD:		EPC page is invalid (and cannot be blocked).
> > > + * %SGX_EPC_PAGE_CONFLICT:	EPC page in use by another SGX instruction.
> > > + * %SGX_INVALID_SIGNATURE:	Enclave's signature does not validate with
> > > + *				public key enclosed in SIGSTRUCT.
> > > + * %SGX_MAC_COMPARE_FAIL:	MAC check failed when reloading EPC page.
> > > + * %SGX_PAGE_NOT_BLOCKED:	EPC page is not marked as blocked.
> > > + * %SGX_NOT_TRACKED:		ETRACK has not been completed on the EPC page.
> > > + * %SGX_VA_SLOT_OCCUPIED:	Version array slot contains a valid entry.
> > > + * %SGX_CHILD_PRESENT:		Enclave has child pages present in the EPC.
> > > + * %SGX_ENCLAVE_ACT:		Logical processors are currently executing
> > > + *				inside the enclave.
> > > + * %SGX_ENTRYEPOCH_LOCKED:	SECS locked for EPOCH update, i.e. an ETRACK is
> > > + *				currently executing on the SECS.
> > > + * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
> > > + *				public key does not match IA32_SGXLEPUBKEYHASH.
> > > + * %SGX_PREV_TRK_INCMPL:	All processors did not complete the previous
> > > + *				tracking sequence.
> > > + * %SGX_PG_IS_SECS:		Target EPC page is an SECS and cannot be
> > > + *				blocked.
> > > + * %SGX_PAGE_ATTRIBUTES_MISMATCH:	Attributes of the EPC page do not match
> > > + *					the expected values.
> > 
> > You sometimes call it "PG" and sometimes "PAGE". Unify?

We pulled the names verbatim from the SDM.  I agree that diverging from
the SDM makes sense.  I'll also see if the SDM can be updated to use
consistent names.

> > > + * %SGX_PAGE_NOT_MODIFIABLE:	EPC page cannot be modified because it is in
> > > + *				the PENDING or MODIFIED state.
> > > + * %SGX_PAGE_NOT_DEBUGGABLE:	EPC page cannot be modified because it is in
> > > + *				the PENDING or MODIFIED state.
> > 
> > Same description text?
> 
> Thanks for the remarks. I think I define only the error codes in the
> next version that actually get used by the driver and document them
> properly. Should become way more cleaner.

Please keep all error codes.  For errors that inevitably occur during
development, it's very helpful to have the complete list in the kernel
(well, reasonably complete).  I hate having to open and search through the
SDM just to decipher a random numeric error code.

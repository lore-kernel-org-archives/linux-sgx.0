Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFC7C433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 16:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F35A22072C
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 16:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbgEVQN1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 12:13:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:51745 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730031AbgEVQN1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 12:13:27 -0400
IronPort-SDR: ME7ueAYrL8h73y7/odPxuvPf8yAugZxyMzN8q77Mbr58EOLjb00yrspaNKnKztY+qRvXkFXVnW
 I52TxY07qbJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 09:13:27 -0700
IronPort-SDR: aiTYSdKjid/eYBaV6pZLf1HOHl+H5tbma3zwq9eKC7nm0xLRccQU1oh04gJqXPVyzrCJ/Ne3El
 5p8VjT3kIK5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="374802477"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 09:13:26 -0700
Date:   Fri, 22 May 2020 09:13:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com, Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 04/20] x86/sgx: Add SGX microarchitectural data
 structures
Message-ID: <20200522161326.GC25128@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-5-jarkko.sakkinen@linux.intel.com>
 <20200520184745.GJ1457@zn.tnic>
 <20200522155405.GA8377@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522155405.GA8377@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 22, 2020 at 06:54:05PM +0300, Jarkko Sakkinen wrote:
> On Wed, May 20, 2020 at 08:47:45PM +0200, Borislav Petkov wrote:
> > On Fri, May 15, 2020 at 03:43:54AM +0300, Jarkko Sakkinen wrote:
> > > +/**
> > > + * struct sgx_sigstruct_header -  defines author of the enclave
> > > + * @header1:		constant byte string
> > > + * @vendor:		must be either 0x0000 or 0x8086
> > 
> > Out of pure curiosity: what is that about?
> > 
> > Nothing in the patchset enforces this, so hw does? If so, why?
> > 
> > Are those vendor IDs going to be assigned by someone or what's up?
> > 
> > Thx.
> 
> In SGX1 world 0x8086 was used to mark architectural enclaves and 0x0000
> user run enclaves. In SGX2 world they are irrelevant.

That's not accurate, the vendor is irrelevant in all SGX eras, e.g. enclaves
signed by someone other than Intel can use 0x8086 on SGX1 hardware and even
pre-LC hardware.  0x8086 is/was used as an _informal_ "this is an
Intel-signed enclave", but in no way was it mandatory or reliable.

> In order to retain compatiblity I'd add an explicit check to:
> 
> 1. Allow vendor ID of 0x0000 or 0x8086.
> 2. Reject other vendor ID's (-EINVAL).

Unless we also check the reserved fields in sigstruct, I don't see the
point.  Even then, I don't understand what the kernel gains from enforcing
anything with respect to sigstruct.  Enforcing the SECS makes sense as we
don't want to allow userspace to enable some unknown future feature.  But
sigstruct is purely for verification, we (Intel) have far bigger problems
if Intel is enabling new behavior via sigstruct.

That being said, I'm not dead set against sanity checking sigstruct, I just
think it'd be a waste of cycles.

Return-Path: <SRS0=fW0T=7C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96035C433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 20 May 2020 21:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733062075F
	for <linux-sgx@archiver.kernel.org>; Wed, 20 May 2020 21:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgETVEn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 May 2020 17:04:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:60965 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgETVEn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 May 2020 17:04:43 -0400
IronPort-SDR: o3Bo0UT+dO6ibuBadmxuVg+z5NlkdXbUgnO/hmW0bdtyM5Gq5LqK8/vqYTd5IDeMcrzt0GT72O
 Y+9rD1fhjAwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 14:04:42 -0700
IronPort-SDR: 4xYjxQw9iQNwd+UAdFu4L3s23woNlbuAhhuV1E0+mLOeQ75curoIzQvYtn3y6Xv8ueWEDlckJw
 pP6x9/dSsilg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,415,1583222400"; 
   d="scan'208";a="289486103"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 20 May 2020 14:04:41 -0700
Date:   Wed, 20 May 2020 14:04:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 04/20] x86/sgx: Add SGX microarchitectural data
 structures
Message-ID: <20200520210441.GD18102@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-5-jarkko.sakkinen@linux.intel.com>
 <20200520184745.GJ1457@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520184745.GJ1457@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 20, 2020 at 08:47:45PM +0200, Borislav Petkov wrote:
> On Fri, May 15, 2020 at 03:43:54AM +0300, Jarkko Sakkinen wrote:
> > +/**
> > + * struct sgx_sigstruct_header -  defines author of the enclave
> > + * @header1:		constant byte string
> > + * @vendor:		must be either 0x0000 or 0x8086
> 
> Out of pure curiosity: what is that about?
> 
> Nothing in the patchset enforces this, so hw does? If so, why?

Yes, enforced by hardware during EINIT.

> Are those vendor IDs going to be assigned by someone or what's up?

No, the field has no real meaning or value, and there is no (and never was
any) intent to use it to create an OEM registry or anything of that nature.

It's effectively a reserved-0 field that happens to allow 0x8086 because of
legacy behavior within Intel's signing sytem.  Intel signed enclaves
currently populate it with 0x8086, but future enclaves may change the vendor
to 0x0 just to avoid confusion.  In short, software should ignore the field.

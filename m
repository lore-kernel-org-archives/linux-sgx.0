Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423FEC4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 11:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3578239D4
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 11:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIXL2L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 07:28:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:16373 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgIXL2L (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 07:28:11 -0400
IronPort-SDR: 190nK8jV78sjHnGgbbyr00u9Q3Tb/c37ZPFYUIxjXaAuPPLz6nsbiV3O+DIrtLrGN6J69MmFnz
 4uaBXN8NsLNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160457571"
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="160457571"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 04:28:10 -0700
IronPort-SDR: 6AaJWL+W/8naSncd7ds/TQNBCRDBKYoSc7qLYzcsk3/4fkbG3+WX2R+VyamwX13Q2vJU66ZQUv
 BZCJFIs+FjRg==
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="486866581"
Received: from ekoteln-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.45.129])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 04:28:04 -0700
Date:   Thu, 24 Sep 2020 14:28:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 23/24] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200924112801.GC56811@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-24-jarkko.sakkinen@linux.intel.com>
 <20200923135005.GI28545@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923135005.GI28545@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 23, 2020 at 03:50:05PM +0200, Borislav Petkov wrote:
> > +This leaf function takes an RSA-3072 signature of the enclave measurement and an
> > +optional cryptographic token. Linux does not take advantage of launch tokens.
> > +The instruction checks that the signature is signed with the key defined in
> > +**IA32_SGXLEPUBKEYHASH?** MSRs and the measurement is correct. If so, the
> 
> That '?' wants to be '[0123]' perhaps?

What do you think of this:

"The leaf instruction checks that the measurement is correct and
signature is signed with the key hashed to the four
+**IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}** MSRs representing the SHA256 of a
public key."

I though that little more detail would make sense here (i.e. what do the
MSRs represent).

/Jarkko

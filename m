Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0FFC4727C
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 15:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A21C2071E
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 15:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgI3P2P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:28:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:56321 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbgI3P2N (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 11:28:13 -0400
IronPort-SDR: k9Hm1PcNCtCfg9m6MNxH31ArA38/mxaCkbc2BI5JjO0yW7kh6pZDrLjQCuGSy3W77Trhr7EGhe
 Sn6z713fscjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="180634704"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="180634704"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:28:11 -0700
IronPort-SDR: g+ftN8bg2AVIKSLrGl3QFGDC3k5p3Hse+SVFX9tE9Koi7BB+lVgEzEk8Fov7MFslm2TALtLEPC
 X9QcYRbFOgzg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="498009790"
Received: from geigerri-mobl.ger.corp.intel.com (HELO localhost) ([10.249.35.47])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:28:08 -0700
Date:   Wed, 30 Sep 2020 18:28:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
Message-ID: <20200930152806.GA52739@linux.intel.com>
References: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
 <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
 <20200930142017.GA49393@linux.intel.com>
 <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 07:33:38AM -0700, Dave Hansen wrote:
> On 9/30/20 7:20 AM, Jarkko Sakkinen wrote:
> > I'm not expert on Spectre, or any sort of security researcher, but I've
> > read a few papers about and understand the general concept. With the
> > constraints how the callback is used in practice, I'd *guess* it is
> > fine to drop retpoline but I really need some feedback on this from
> > people who understand these attacks better.
> 
> Do you recall why you added it in the first place?  What was the
> motivation for it?  Were you responding to a review comment?

Absolutely cannot recall it :-) I even cannot recall the exact time when
we landed the vDSO in the first place. Too much stuff has happend during
the long three year upstreaming cycle. I will try to backtrack this
info.

/Jarkko

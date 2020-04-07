Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2854C2BA1A
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 18:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05712063A
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 18:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgDGSEP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 14:04:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:14320 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgDGSEP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Apr 2020 14:04:15 -0400
IronPort-SDR: 0gNig89qdcilTM5101/vtFsp1LVqwBf0KBpHfPAiHRVf9s+yo7If2xQRWQl2SbEsuC490eeIWz
 9doz2WANlUkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 11:04:14 -0700
IronPort-SDR: ABOmKgs0D4vM5WVTJgsMuXwd++WzlR9Wr9ma1a1mOd2mnM1iLO/GGrBOJSK9xNiKRZ24rdNnQ+
 VC8O6Z5vZ5rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,356,1580803200"; 
   d="scan'208";a="424837349"
Received: from krausest-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.49])
  by orsmga005.jf.intel.com with ESMTP; 07 Apr 2020 11:04:11 -0700
Date:   Tue, 7 Apr 2020 21:04:10 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200407180410.GA17916@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
 <20200407165704.GA14583@linux.intel.com>
 <20200407165900.GB14583@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407165900.GB14583@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 07, 2020 at 07:59:00PM +0300, Jarkko Sakkinen wrote:
> On Tue, Apr 07, 2020 at 07:57:08PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Apr 07, 2020 at 12:04:58PM +0300, Topi Miettinen wrote:
> > > Please correct me if I'm wrong, but isn't it the goal of SGX to let a
> > > (suitably privileged) process designate some of its memory areas as part of
> > > SGX enclave? If so, why don't you simply add a system call to do so, such as
> > > 
> > > int sgx_mprotect(void *start, size_t length, int prot, u64 sgx_flags);
> > > 
> > > like existing pkey_mprotect()? Or add a flag PROT_SGX to mprotect() like
> > > existing PROT_SAO/PROT_SEM?
> > > 
> > > -Topi
> > 
> > New syscalls is always the last resort path, especially if they are
> > associated with an arch.
> > 
> > PROT_SGX sounds something worth of consideration.
> > 
> > Another idea to throw would be noexec_dev mount option that would allow
> > exec *only* for the device nodes (zero analysis done on feasibility).
> 
> The 2nd proposal has the merit that it would scale above SGX and
> does not give additional strengths to the adversary in the context
> of the threat scenario.

Or.

Why couldn't kernel just disallow anything but device files to be
created to devtmpfs unconditionally?

Then noexec would not be needed in the first place.

/Jarkko

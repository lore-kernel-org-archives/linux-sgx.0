Return-Path: <SRS0=yCNl=7J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EE9C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 19:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5572088E
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 19:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgE0Tnj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 May 2020 15:43:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:50991 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgE0Tnj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 May 2020 15:43:39 -0400
IronPort-SDR: GRHZFPEodn44ButcYfPfFb+sFRWqP9BqSWzKdh1G6tHFkz3GUFqNcBRC0vm6ugRcvwN0uuU9wz
 ErRn4kTWcESw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 12:43:38 -0700
IronPort-SDR: hF0sOxrU7ydoJBeclUjIZCnUA5GkejfLmzFCFF2Hx5631FpY/5rLxCejvBNaRxbsHB+vIOsqLd
 JLwP3RIYPvAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="468836609"
Received: from lkakolx-mobl.ger.corp.intel.com ([10.249.43.73])
  by fmsmga005.fm.intel.com with ESMTP; 27 May 2020 12:43:29 -0700
Message-ID: <b3a48fc26bbb680273fc744f930dcfed5e503829.camel@linux.intel.com>
Subject: Re: [PATCH v30 04/20] x86/sgx: Add SGX microarchitectural data
 structures
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Date:   Wed, 27 May 2020 22:43:28 +0300
In-Reply-To: <20200525082013.GC25636@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
         <20200515004410.723949-5-jarkko.sakkinen@linux.intel.com>
         <20200520184745.GJ1457@zn.tnic> <20200522155405.GA8377@linux.intel.com>
         <20200522161326.GC25128@linux.intel.com>
         <20200522195017.GA121470@linux.intel.com> <20200525082013.GC25636@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2020-05-25 at 10:20 +0200, Borislav Petkov wrote:
> On Fri, May 22, 2020 at 10:50:17PM +0300, Jarkko Sakkinen wrote:
> > If other values except two are never going to be used it is more than a
> > legit point to validate this field.
> > 
> > It also the potential to use ~0x8086 bits to be defined later if ever
> > needed lets say for some kernel specific purpose.
> 
> Yah, let's cover our ass for the future. We have all seen the "this
> won't be used" but then "we're using it" change of heart. IOW, let's
> align with what the hw checks and we can always relax that in the future
> but not the other way around.
> 
I fully agree with this conclusion and that is exactly how I think about
the issue too. I'll add a check for this.

/Jarkko


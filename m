Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87D4C432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 14:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9AC421D80
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 14:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438101AbfIYOrG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 10:47:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:43839 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437125AbfIYOrG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 10:47:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 07:47:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,548,1559545200"; 
   d="scan'208";a="188798997"
Received: from kmakows-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.225])
  by fmsmga008.fm.intel.com with ESMTP; 25 Sep 2019 07:46:58 -0700
Date:   Wed, 25 Sep 2019 17:46:57 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: Re: [PATCH v22 04/24] x86/cpu/intel: Detect SGX supprt
Message-ID: <20190925144657.GA23867@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-5-jarkko.sakkinen@linux.intel.com>
 <20190924161301.GI19317@zn.tnic>
 <20190924174311.GB16218@linux.intel.com>
 <20190924182119.GL19317@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924182119.GL19317@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 24, 2019 at 08:21:19PM +0200, Borislav Petkov wrote:
> On Tue, Sep 24, 2019 at 10:43:11AM -0700, Sean Christopherson wrote:
> > The intent of running on every CPU is to verify MSR_IA32_FEATURE_CONTROL
> > is correctly configured on all CPUs.  It's extremely unlikely that
> > firmware would misconfigure or fail to write the MSR on only APs, but if
> > that does happen we'll spam dmesg and possibly panic or hang the kernel.
> > 
> > The severity of the fallout is why we're being paranoid.  KVM is similarly
> > paranoid about VMX enabling since it'll BUG() on an unexpected fault due
> > to a misconfigured FEATURE_CONTROL.
> 
> None of that is in the commit message or written anywhere AFAICT. And my
> crystal ball doesn't show it either so please write down properly why
> this is needed. Better over the function as a comment I'd say.

Added a remark:

    The check is done for every CPU, not just BSP, in order to verify that
    MSR_IA32_FEATURE_CONTROL is correctly configured on all CPUs. The other
    parts of the kernel, like the enclave driver, expect the same
    configuration from all CPUs.

I think here is not necessary to go into KVM implementation details to
make a case for this one. This is just a sane contract/expectation for
anything using SGX and thus it is better to validate it before anything
gets to use it.

/Jarkko

Return-Path: <SRS0=OFrI=N5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6C6C43441
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 08:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E2E920659
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 08:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E2E920659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbeKRS5W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Nov 2018 13:57:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:15818 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbeKRS5W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Nov 2018 13:57:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2018 00:37:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,247,1539673200"; 
   d="scan'208";a="107227354"
Received: from kaczmarx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.89])
  by fmsmga004.fm.intel.com with ESMTP; 18 Nov 2018 00:37:32 -0800
Date:   Sun, 18 Nov 2018 10:37:28 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Wang <davidwang@zhaoxin.com>,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        Jia Zhang <qianyue.zj@alibaba-inc.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 06/23] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20181118083728.GM5897@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-7-jarkko.sakkinen@linux.intel.com>
 <71af0361-3296-42a2-d76f-4f1e26e676b8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71af0361-3296-42a2-d76f-4f1e26e676b8@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:32:36PM -0800, Dave Hansen wrote:
> On 11/15/18 5:01 PM, Jarkko Sakkinen wrote:
> > +static void detect_sgx(struct cpuinfo_x86 *c)
> > +{
> > +	unsigned long long fc;
> > +
> > +	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> > +	if (!(fc & FEATURE_CONTROL_LOCKED)) {
> > +		pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
> > +		goto out_unsupported;
> > +	}
> 
> This needs a check against the config option somewhere so the compiler
> can toss it in its entirety if SGX is config'd out.

Certainly. I'll flag it in the next version.

/Jarkko

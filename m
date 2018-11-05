Return-Path: <SRS0=4Rt9=NQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CAAC46475
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63DE620685
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63DE620685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbeKEX6A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:58:00 -0500
Received: from mga17.intel.com ([192.55.52.151]:47376 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbeKEX6A (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Nov 2018 18:58:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2018 06:37:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,468,1534834800"; 
   d="scan'208";a="105405589"
Received: from fhoeg-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.66])
  by fmsmga001.fm.intel.com with ESMTP; 05 Nov 2018 06:37:50 -0800
Date:   Mon, 5 Nov 2018 16:37:49 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        davidwang@zhaoxin.com,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        qianyue.zj@alibaba-inc.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 14/23] x86/cpu/intel: Clear SGX_LC capability if not
 enabled in FEATURE_CONTROL
Message-ID: <20181105143749.GB2798@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-15-jarkko.sakkinen@linux.intel.com>
 <CAHp75VctUJRTecG4rVHXm0uO18ZndMgqJgtNyG25HtSzJF5uzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VctUJRTecG4rVHXm0uO18ZndMgqJgtNyG25HtSzJF5uzg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181105143749.tGuY5HtqARxPsDdssHezlDmF4-RgaCcoVnoB1urBgEU@z>

On Sat, Nov 03, 2018 at 03:15:15PM +0200, Andy Shevchenko wrote:
> > @@ -618,6 +618,8 @@ static void detect_sgx(struct cpuinfo_x86 *c)
> >                 setup_clear_cpu_cap(X86_FEATURE_SGX1);
> >                 setup_clear_cpu_cap(X86_FEATURE_SGX2);
> >         }
> > +       if (unsupported || !(fc & FEATURE_CONTROL_SGX_LE_WR))
> > +               setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> >  }
> 
> A-ha, I see how you use this variable here (though it's still possible
> to get rid of it, choose what is better for readability /
> maintenance).

I would propose to squash this one to the earlier commit and refactor
it in a way that I proposed. Having this part as a separate commit in
my opinion is a bit confusing.

/Jarkko

Return-Path: <SRS0=WnqF=OD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A18C43441
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 13:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C14E20868
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 13:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C14E20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbeKYAne (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 24 Nov 2018 19:43:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:12383 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbeKYAne (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 24 Nov 2018 19:43:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Nov 2018 05:55:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,273,1539673200"; 
   d="scan'208";a="110766258"
Received: from djustese-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.168])
  by fmsmga001.fm.intel.com with ESMTP; 24 Nov 2018 05:54:35 -0800
Date:   Sat, 24 Nov 2018 05:54:31 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20181124135431.GA7048@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-7-jarkko.sakkinen@linux.intel.com>
 <20181121181728.GA27559@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121181728.GA27559@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 21, 2018 at 07:17:28PM +0100, Borislav Petkov wrote:
> I see the build failure here has been pointed out already but lemme
> repeat it out for another reason:
> 
> It is very important that no patch we merge breaks bisectability -
> please build every patch before sending:

Yep, the patch ordering was incorrect. I agree and will check this
for the next version. Thanks for your remarks.

/Jarkko

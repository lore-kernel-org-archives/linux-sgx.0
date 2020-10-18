Return-Path: <SRS0=sUAi=DZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705C0C433E7
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Oct 2020 04:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3227C21D47
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Oct 2020 04:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgJRE2E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Oct 2020 00:28:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:19753 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgJRE2E (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Oct 2020 00:28:04 -0400
IronPort-SDR: CYeAPZlUVUIGI7JthHEKpr1Wy5wlo2+JXP2mJol7gm/nZLDrgX3Q+flg2bLeOjFz/PP/ikUWHn
 ltcPO7QLr2hg==
X-IronPort-AV: E=McAfee;i="6000,8403,9777"; a="154653644"
X-IronPort-AV: E=Sophos;i="5.77,388,1596524400"; 
   d="scan'208";a="154653644"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2020 21:28:02 -0700
IronPort-SDR: MJm0CZGR4cqf8pcW36r4CUk8IxztCRmHjNztncgAJ8XpWMnbQqIHLKioEhFH7N9RbE5ZvxLv6T
 n5jinlZWdzAQ==
X-IronPort-AV: E=Sophos;i="5.77,388,1596524400"; 
   d="scan'208";a="301049074"
Received: from hebenstp-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.54.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2020 21:27:52 -0700
Date:   Sun, 18 Oct 2020 07:27:46 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 24/24] x86/sgx: Update MAINTAINERS
Message-ID: <20201018042746.GJ68722@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-25-jarkko.sakkinen@linux.intel.com>
 <7a1890c2-c057-98d9-aa57-23a1b4b90fb0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a1890c2-c057-98d9-aa57-23a1b4b90fb0@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 16, 2020 at 02:04:05PM -0700, Dave Hansen wrote:
> On 10/2/20 9:50 PM, Jarkko Sakkinen wrote:
> > +INTEL SGX
> > +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > +M:	Sean Christopherson <sean.j.christopherson@intel.com>
> > +L:	linux-sgx@vger.kernel.org
> > +S:	Maintained
> 
> Should be Supported, not Maintained.

Thanks, fixed.

/Jarkko

Return-Path: <SRS0=squH=AO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F06C433E0
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 23:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E085420747
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 23:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgGCXEe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Jul 2020 19:04:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:10153 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgGCXEe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Jul 2020 19:04:34 -0400
IronPort-SDR: YdTAHe3hcPFWhDYNT3f4TFRh0XJlc8ko16y62KOfDNh9e4/LVqCYoGMAQ6bN5kLxj/B4FYMsyb
 X8r6fs+AOgZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="144722418"
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="144722418"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 16:04:33 -0700
IronPort-SDR: JyuK2FYE/yBdERc+4D1NOJZ7N0JJg+gCfVSVJ/LJ4h0rRpghX+gjWdxYshCfKx1IW4im/D3h4V
 /WOU9Vp5CXkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="456023767"
Received: from ntohan-mobl.ger.corp.intel.com (HELO localhost) ([10.252.53.15])
  by orsmga005.jf.intel.com with ESMTP; 03 Jul 2020 16:04:17 -0700
Date:   Sat, 4 Jul 2020 02:04:13 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200703230413.GA104749@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200626091419.GB27151@zn.tnic>
 <20200626141627.GA6583@linux.intel.com>
 <20200626142019.GD27151@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626142019.GD27151@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 26, 2020 at 04:20:19PM +0200, Borislav Petkov wrote:
> On Fri, Jun 26, 2020 at 07:16:27AM -0700, Sean Christopherson wrote:
> > That being said, I agree that it would be safer to move sgx_calc_ssaframesize()
> > inside sgx_validate_secs() and only compute encl_size after the secs is
> > validated.
> 

Changed as

if (!secs->ssa_frame_size)
	return -EINVAL;

if (sgx_calc_ssa_frame_size(secs->miscselect, secs->xfrm) >
    secs->ssa_frame_size)
	return -EINVAL;

/Jarkko

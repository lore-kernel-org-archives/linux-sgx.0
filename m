Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FF5C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF52E20789
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390690AbgFYUMS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:12:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:41702 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390575AbgFYUMQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 16:12:16 -0400
IronPort-SDR: /KpMIHEjmyAHOTCOvbS5/Yp1Ov+t7NdXpvyIREgM9huyBHP34b3h4jYD2Kvj8bxiBv5DcalEbV
 hngo9hoh2FhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="124712828"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="124712828"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 13:12:14 -0700
IronPort-SDR: 3/h5lshevaYkf9k9GfMxmGa4KC/GEZ+r0sxQ5Ojx9FL0kZ60xlkU7/3/1ZSwkzqLJilXV+Pfzz
 MbpKSRgy37Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="479596179"
Received: from drews-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.247])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jun 2020 13:12:02 -0700
Date:   Thu, 25 Jun 2020 23:11:56 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 08/21] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20200625201156.GA15394@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-9-jarkko.sakkinen@linux.intel.com>
 <20200625101441.GC20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625101441.GC20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 12:14:41PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:30AM +0300, Jarkko Sakkinen wrote:
> > +static inline struct sgx_epc_section *sgx_get_epc_section(
> > +		struct sgx_epc_page *page)
> 
> Just let it stick out - breaking lines on arg opening brace are the
> ugliest. Also:
> 
>   bdc48fa11e46 ("checkpatch/coding-style: deprecate 80-column warning")
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

OK, I put everything into one line.

/Jarkko

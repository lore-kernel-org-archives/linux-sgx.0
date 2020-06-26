Return-Path: <SRS0=bCPb=AH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1CBC433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 13:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B8F820781
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 13:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgFZNe3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Jun 2020 09:34:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:12083 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgFZNe3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 26 Jun 2020 09:34:29 -0400
IronPort-SDR: KW+R25eSM6aMT4saly2B5CK37zHqp7pmMI+g/T8yQLF4AlONkWEro3wcsSu/hA4/gTCp7/4ZnV
 KriHLrOU/+WA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="142827160"
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="142827160"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 06:34:28 -0700
IronPort-SDR: 38r1TGNgx5GlLKzsoWczB07XaCRP4t2bNFAD7rFygOJaP3B2kpUZVLmesRP6FjYOuf8TeEcWDR
 f0YR31KtTtjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="354775384"
Received: from cgheban-mobl.ger.corp.intel.com (HELO localhost) ([10.249.40.199])
  by orsmga001.jf.intel.com with ESMTP; 26 Jun 2020 06:34:16 -0700
Date:   Fri, 26 Jun 2020 16:34:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 03/21] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200626133414.GD7853@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-4-jarkko.sakkinen@linux.intel.com>
 <20200625085931.GB20319@zn.tnic>
 <20200625205211.GC15394@linux.intel.com>
 <20200625211103.GR20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625211103.GR20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 11:11:03PM +0200, Borislav Petkov wrote:
> On Thu, Jun 25, 2020 at 11:52:11PM +0300, Jarkko Sakkinen wrote:
> > I ended up with:
> > 
> >  *   bit 5 ==				1: protection keys block access
> >  *   bit 6 ==				1: inside SGX enclave
> 
> You mean bit 15.

Duh, did this last thing before falling into sleep last night :-/

Yes, it should be 15.

I'll also rephrase the text to "inside an SGX enclave".

/Jarkko

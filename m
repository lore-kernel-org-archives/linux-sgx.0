Return-Path: <SRS0=GMJ6=D6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CE1C55178
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 09:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5672B22253
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 09:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461002AbgJWJCB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Oct 2020 05:02:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:4355 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460812AbgJWJCB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Oct 2020 05:02:01 -0400
IronPort-SDR: Xn34EuT6+opL3URXNAv1SwYiL3L5HxRs/KfTykG1gtQ1H1vteGpxYaKqY981gjCaH95WLv4zX/
 Ekjygh+VzSLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="165056223"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="165056223"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 02:01:53 -0700
IronPort-SDR: 6tzpBxuGjJtkyyn2Y+eNJoGE9sbBdaNp04HxKPfGOSMojLMOPpJJn+lybR3uyTh7BFtPd1AC8E
 HCpnNdppR//g==
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="534323340"
Received: from spiccard-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.38])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 02:01:40 -0700
Date:   Fri, 23 Oct 2020 12:01:37 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 08/24] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20201023090137.GA168477@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-9-jarkko.sakkinen@linux.intel.com>
 <20201019084558.GA1155569@kapsi.fi>
 <20201019123934.GA24325@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019123934.GA24325@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 02:39:34PM +0200, Borislav Petkov wrote:
> On Mon, Oct 19, 2020 at 11:45:58AM +0300, Jarkko Sakkinen wrote:
> > On Sat, Oct 03, 2020 at 07:50:43AM +0300, Jarkko Sakkinen wrote:
> > > +config INTEL_SGX
> > 
> > Since the directory for this was renamed some iterations ago from
> > arch/x86/kernel/cpu/sgx to intel_sgx given the feedback from Boris,
> > I'm wondering should this also be renamed as X86_SGX?
> 
> I don't think it matters. I hardly doubt there will be anything else
> "SGX" besides the Intel one...

Yeah, especially since it'd be namespaced to x86 (not CONFIG_SGX).

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko

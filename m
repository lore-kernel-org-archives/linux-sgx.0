Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166FCC2D0E2
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 12:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D887121D7F
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 12:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgIXMXR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 08:23:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:65043 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgIXMXR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 08:23:17 -0400
IronPort-SDR: yXlb2gr95FFpeyHc223HniVlsD6pA8MDyQgRhnlNQPPWbh+ljJ01odseu186aVpEAwF2Jvx9El
 rsCNkqBVMnkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="245978468"
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="245978468"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 05:23:16 -0700
IronPort-SDR: tL64HsL88rFswz9buK9wCSiw6bSsBblAzA8Rf4ZycrWnd6lgyn5dfaZormymnXf1e3szx5i/vS
 4uT6TlU+juDA==
X-IronPort-AV: E=Sophos;i="5.77,297,1596524400"; 
   d="scan'208";a="486881950"
Received: from mkoeck-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.48.209])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 05:23:09 -0700
Date:   Thu, 24 Sep 2020 15:23:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
Message-ID: <20200924122307.GF56811@linux.intel.com>
References: <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
 <20200921181021.GA24481@linux.intel.com>
 <20200921182753.GK5901@zn.tnic>
 <20200921191658.GA24823@linux.intel.com>
 <20200922082918.GC22660@zn.tnic>
 <a6f4d3e5-c128-fcd7-a1ca-5515a6c4c09a@fortanix.com>
 <20200922142909.GI22660@zn.tnic>
 <20200923144707.GF5160@linux.intel.com>
 <20200923155511.GN28545@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923155511.GN28545@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 23, 2020 at 05:55:11PM +0200, Borislav Petkov wrote:
> On Wed, Sep 23, 2020 at 05:47:07PM +0300, Jarkko Sakkinen wrote:
> > OK, so I did not follow this particular discussion in high detail,
> 
> What do you mean you did not follow it? It is not a huge subthread in
> your mbox.

I focused on other subthreads but I've read it now through. It has been
waiting in the queue. Can't do everything simultaneously. I did skim
each message as they came for this one though.

> > so as a sanity check I'll preview my changes.
> 
> Sorry, but you'll have to read threads properly like everyone else.
> 
> In any case, my preference would be make it the simplest possible: no
> cache and try EINIT only once.


The main reason skimming was that I was thinking that perhaps Sean might
send a patch for this one and I would then read the thread again in
better detail and check that the patch matches the conclusions, as he
has been more active on this one.

Anyway, now that I've read it through in detail, I did just change the
init simply as:

secs_addr = sgx_get_epc_addr(encl->secs.epc_page);

preempt_disable();
ret = __einit(sigstruct, token, secs_addr);
preempt_enable();

I use a local for address to make the code  more readable instead of
calling sgx_get_epc_addr() inside __einit().

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko

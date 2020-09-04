Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24ADAC43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 16:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 032E020795
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 16:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgIDQB1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 12:01:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:39922 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgIDQB0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 12:01:26 -0400
IronPort-SDR: Gl5SQKPBtW2ZsNL/Yt+nhGj7gHCpJYZTC+Nw2QUMyQMqVThfQdq6sgZijZ5QJqPFFhk+K88geO
 r39EzDI4Ve7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="137822434"
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="137822434"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 09:01:24 -0700
IronPort-SDR: jxNds4SCBKpf9qabf+QA8d1gFzMMSwS4VWmTrLCBKpVVhGqTyTrx7Lx6Rdcuw3STcpfFMk7T4h
 Mojv4r0hIRig==
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="284472926"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 09:01:24 -0700
Date:   Fri, 4 Sep 2020 09:01:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200904160123.GB2206@sjchrist-ice>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <74e185a6-909a-af54-9a09-e8f9c8809703@fortanix.com>
 <20200824194941.GC7391@linux.intel.com>
 <20200904102507.GA8435@sjchrist-ice>
 <20200904133631.GF39023@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904133631.GF39023@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 04, 2020 at 04:36:31PM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 04, 2020 at 03:25:07AM -0700, Sean Christopherson wrote:
> > On Mon, Aug 24, 2020 at 10:49:41PM +0300, Jarkko Sakkinen wrote:
> > > This documentation should be moved to Documentation/x86/sgx.rst.
> > > 
> > > It is easier to read from there and then it will be included by kdoc
> > > to the kernel documentation. In here it is not addressed by kdoc and
> > > it is unnecessarily hard to read.
> > 
> > I'm confused, this is all picked up by kernel-doc.  What am I missing?
> 
> Right of course, it is in the .h file now. Sorry, it is me being blind.

No worries.

> Was it before in the .S file?

Yeah, it was originally in the .S file with an #ifdef hack to trick
kernel-doc into parsing the comment.  It got moved to the .h when the vDSO
was changed to be directly callable from C.

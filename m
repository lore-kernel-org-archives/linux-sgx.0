Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C4BC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 14:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EC9320672
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 14:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732525AbgF3OU3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 10:20:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:5925 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbgF3OU3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 30 Jun 2020 10:20:29 -0400
IronPort-SDR: 5TZ9PARI6vG+GWgZTySC0Et54C4D45a6kehKp9tCz7Zx8Fep6lYXffXG7LuCz2/SM+YyYJo7bM
 1mtKTbl5UREw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134539839"
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="134539839"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 07:20:28 -0700
IronPort-SDR: efg8NFLHdEGkXUz1Q7b/UefrYDvt7xyvu1AY0n6E6z0KV5aKd6d/pEDVM7jcCMBajo0ma20fla
 norTNhzCl/1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="277440490"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 30 Jun 2020 07:20:28 -0700
Date:   Tue, 30 Jun 2020 07:20:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 12/21] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
Message-ID: <20200630142027.GA7733@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
 <20200629160242.GB32176@zn.tnic>
 <20200629220400.GI12312@linux.intel.com>
 <20200630084956.GB1093@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630084956.GB1093@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 30, 2020 at 10:49:56AM +0200, Borislav Petkov wrote:
> On Mon, Jun 29, 2020 at 03:04:00PM -0700, Sean Christopherson wrote:
> > /dev/sgx/provision is root-only by default, the expectation is that the admin
> > will configure the system to grant only specific enclaves access to the
> > PROVISION_KEY.
> 
> Uuh, I don't like "the expectation is" - the reality happens to turn
> differently, more often than not.

Would it help if I worded it as "only root should ever be able to run an
enclave with access to PROVISION_KEY"?  We obviously can't control what
admins actually do, hence my wording of it as the expected behavior.

> > In this series, access is fairly binary, i.e. there's no additional kernel
> > infrastructure to help userspace make per-enclave decisions.  There have been
> > more than a few proposals on how to extend the kernel to help provide better
> > granularity, e.g. LSM hooks, but it was generally agreed to punt that stuff
> > to post-upstreaming to keep things "simple" once we went far enough down
> > various paths to ensure we weren't painting ourselves into a corner.
> 
> So this all sounds to me like we should not upstream /dev/sgx/provision
> now but delay it until the infrastructure for that has been made more
> concrete. We can always add it then. Changing it after the fact -
> if we have to and for whatever reason - would be a lot harder for a
> user-visible interface which someone has started using already.

The userspace and attestation infrastructure is very concrete, i.e. the
need for userspace to be able to access PROVISION_KEY is there, as is the
desire to be able to restrict access to PROVISION_KEY, e.g. I believe Andy
Lutomirski originally requested the ability to restrict access.

The additional infrastructure for per-enclave decisions is somewhat
orthogonal to the PROVISION_KEY, e.g. they won't necessarily be employed
by everyone running enclaves, and environments that do have per-enclave
policies would still likely want the extra layer of restriction for
PROVISION_KEY.  I only brought the additional policy crud to call out that
we've done enough path-finding on additional restrictions to have strong
confidence that adding /dev/sgx/provision won't prevent us from adding more
fine grained control in the future.

> So I'd leave  that out from the initial patchset.

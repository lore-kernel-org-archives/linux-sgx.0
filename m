Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A81DC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 08:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10172206BE
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 08:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="bShX4bZP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgF3IuA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 04:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731697AbgF3It6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 30 Jun 2020 04:49:58 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C2FC061755;
        Tue, 30 Jun 2020 01:49:58 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0eff00c5d3fc2efff9f4b6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:ff00:c5d3:fc2e:fff9:f4b6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E29EB1EC031B;
        Tue, 30 Jun 2020 10:49:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593506997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oRm5RCCRuDGEyj0/k3JMpu55Vd9Mg+DkgrloRPSHKKU=;
        b=bShX4bZPlos7EtZLnpbbtTAkxmhr3YrU3PnjxMTqUOxbp3itPr5gLZYhn1dfEppciaUVRt
        ++TME2mCXjoMni8syGG0MYTWKTIi1L8eHYWdkU7cpQ/9LRvaTJc4v7OBhZS2gDG4wqq39o
        dzz0/sVJPqnNkz8mZS6fMEKso7xmF2A=
Date:   Tue, 30 Jun 2020 10:49:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20200630084956.GB1093@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
 <20200629160242.GB32176@zn.tnic>
 <20200629220400.GI12312@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200629220400.GI12312@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 29, 2020 at 03:04:00PM -0700, Sean Christopherson wrote:
> > I don't see this acronym resolved anywhere in the whole patchset.
> 
> Quoting Enclave.

Yah, pls add it somewhere.

> /dev/sgx/provision is root-only by default, the expectation is that the admin
> will configure the system to grant only specific enclaves access to the
> PROVISION_KEY.

Uuh, I don't like "the expectation is" - the reality happens to turn
differently, more often than not.

> In this series, access is fairly binary, i.e. there's no additional kernel
> infrastructure to help userspace make per-enclave decisions.  There have been
> more than a few proposals on how to extend the kernel to help provide better
> granularity, e.g. LSM hooks, but it was generally agreed to punt that stuff
> to post-upstreaming to keep things "simple" once we went far enough down
> various paths to ensure we weren't painting ourselves into a corner.

So this all sounds to me like we should not upstream /dev/sgx/provision
now but delay it until the infrastructure for that has been made more
concrete. We can always add it then. Changing it after the fact -
if we have to and for whatever reason - would be a lot harder for a
user-visible interface which someone has started using already.

So I'd leave  that out from the initial patchset.

> If you want super gory details, Intel's whitepaper on attestation in cloud
> environments is a good starting point[*], but I don't recommended doing much
> more than skimming unless you really like attestation stuff or are
> masochistic, which IMO amount to the same thing :-)

No thanks. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

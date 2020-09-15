Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0946DC433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1D5F2078E
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4Fq7zow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgIPAfP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:35:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgIONbE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Sep 2020 09:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600176604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/cZ5S90LvfH2YJYUGQ9z5j9iiMm9I7jxn7rvlohnMLk=;
        b=Q4Fq7zow+AfcGQeijopLkolzAT6KEQAh0l9+2Gp4XijKW/HlXoeCKZUYZtaZTP1YXIfRJZ
        yofb15OXK6cCAc6qcZuzukbLeKxSM8T4nUYAYel805Gokou0tZG8sbUclHE1dEzRj6CnBF
        ZZTGCfnJ/ze6NBl+bsZISAneCYJUysA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-Zg1z-YgENxyUPmq8b_SO_g-1; Tue, 15 Sep 2020 09:27:47 -0400
X-MC-Unique: Zg1z-YgENxyUPmq8b_SO_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9D7E1882FC9;
        Tue, 15 Sep 2020 13:27:41 +0000 (UTC)
Received: from treble (ovpn-112-136.rdu2.redhat.com [10.10.112.136])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 849BA75144;
        Tue, 15 Sep 2020 13:27:27 +0000 (UTC)
Date:   Tue, 15 Sep 2020 08:27:25 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v37 02/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200915132725.a2qbdio3jsu7rsqs@treble>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-3-jarkko.sakkinen@linux.intel.com>
 <20200914151816.u6camicid4bd5lgo@treble>
 <20200914153812.c6uh3spqmcy2ft3d@treble>
 <20200915095716.GI3612@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915095716.GI3612@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 12:57:16PM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 14, 2020 at 10:38:26AM -0500, Josh Poimboeuf wrote:
> > On Mon, Sep 14, 2020 at 10:18:16AM -0500, Josh Poimboeuf wrote:
> > > Hi Jarko,
> > > 
> > > It looks like some of the patches weren't delivered to the lists.
> > > Patches 0, 1, 8, 9, and 17 seem to be missing.
> > > 
> > > Lore agrees with me:
> > > 
> > >   https://lore.kernel.org/linux-sgx/20200911124019.42178-1-jarkko.sakkinen@linux.intel.com/
> > 
> > And my first email to you bounced, similar to an email I tried sending
> > to Kristen a few weeks ago.  Something weird going on with Intel mail
> > servers?
> 
> Possible. I don't honestly know what is going on.
> 
> At least now all the patches are out:
> 
> https://lore.kernel.org/linux-sgx/
> 
> Not sure if a resend would make sense for the full patch set but maybe I
> just do quick iteration and send v38 soon. And just in case use some alt
> smtp server.

I see the v37 missing patches now, but they're not threaded with the
original thread.  v38 has some missing patches as well.

-- 
Josh


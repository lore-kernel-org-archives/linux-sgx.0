Return-Path: <SRS0=1eu2=SH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72671C4360F
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Apr 2019 14:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4295F21871
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Apr 2019 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554474118;
	bh=nbv5ZGZk14WDH9xUQh8JcOBBmi5P4sixfntAktwNZL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=P1czeLHVSQ5oFf9G5t/vSZN9yJphzbYjByYqlohU67w0kbQ9UErVKy9GZy0v59vNo
	 3cjIy0Dza05gL0nZH9BRr90s2xq5tg9NmuFFG9Fe9wIqPQr3abpt4aYgB6Bb1n1nAf
	 FW9+dnc7OobqR1FDtI490drlWYce/yoJ+l1xgoyg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbfDEOV5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbfDEOV5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Apr 2019 10:21:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDC4205F4;
        Fri,  5 Apr 2019 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554474116;
        bh=nbv5ZGZk14WDH9xUQh8JcOBBmi5P4sixfntAktwNZL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xe1EgWZOqpFr2kZcI/ApGvQscE0sfd33rD2UIgHr9WOB/jodeT0uU2J7iKH72bBOs
         kRYuhWQz92zt8fvSaoPK8mvFdz/Sswxe0kxRNsb0YROWb8pUV3iIkVMWoYSEWZBMgu
         Vp0RgE6qxg59XluVG2ggpzbdhlygoVplUQ9MWv5U=
Date:   Fri, 5 Apr 2019 16:21:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
Message-ID: <20190405142153.GB12954@kroah.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
 <20190322112938.GJ3122@linux.intel.com>
 <20190322114325.GA10165@linux.intel.com>
 <CALCETrW=Fr8EdVq+5FLbmdL__i82FC0ONHd=hBXjxpLcsv9M0Q@mail.gmail.com>
 <20190325145503.GB29989@linux.intel.com>
 <20190405101817.GA9816@linux.intel.com>
 <CALCETrWEhcx+Uak+Rmh5F4DvY6=G3nYcMhsN3o1XvdxrGNtsqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWEhcx+Uak+Rmh5F4DvY6=G3nYcMhsN3o1XvdxrGNtsqA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 05, 2019 at 06:53:57AM -0700, Andy Lutomirski wrote:
> On Fri, Apr 5, 2019 at 3:18 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Mon, Mar 25, 2019 at 04:55:03PM +0200, Jarkko Sakkinen wrote:
> > > > > Hmm.. on 2nd thought the LSM policy or even DAC policy  would restrict
> > > > > that the container manager can only access specific files inside
> > > > > securityfs. With this conclusion I still think it is probably the best
> > > > > place for seurity policy like things even for SGX. It is meant for that
> > > > > anyway.
> > > > >
> > > >
> > > > LSM or DAC policy can certainly *restrict* it, but I suspect that most
> > > > container runtimes don't mount securityfs at all.  OTOH, the runtime
> > > > definitely needs to have a way to pass /dev/sgx/enclave (or whatever
> > > > it's called) through, so using another device node will definitely
> > > > work.
> > >
> > > OK, I can cope with this argument. I go with the device names above for
> > > v20.
> >
> > In v20 the refactoring would be with corresponding modes:
> >
> > /dev/sgx 0755
> > /dev/sgx/enclave 0666
> > /dev/sgx/provision 0600
> >
> > The problem that I'm facing is that with devnode callback of struct
> > device_type I can easily give the defaut mode for any of the files but
> > not for the /dev/sgx directory itself. How do I get the appropriate
> > mode for it?
> >
> 
> Hi Greg-
> 
> Do you know this one?

You can't get the mode of the directory, it is always 0755 for devtmpfs,
is that a problem?  If so, write a udev rule to change it :)

thanks,

greg k-h

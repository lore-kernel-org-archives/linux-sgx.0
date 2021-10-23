Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13637C433EF
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Oct 2021 06:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D932760EE2
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Oct 2021 06:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhJWGgK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 23 Oct 2021 02:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhJWGgH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 23 Oct 2021 02:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC0276103D;
        Sat, 23 Oct 2021 06:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634970827;
        bh=ToY9cthmpH776XZ9pAm3vJZoDsXA4a/qeyjEp6J/sqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EX+jAJg7a/lAsi1U8rGIJtl8iR7JJF4DVaHk67yHFkjzZShjtDOTzbQEaN6CCnqQ+
         tZcl0Ype3aIBcDdCAZ1ezgA2+nXEnA0hxKzPh/whdqzCeE99SuxMdoni0nwZ9OS6V0
         8iv4xGdEB13UkMhhRAy4/1lX0lWnnzYbl3oM1vfA=
Date:   Sat, 23 Oct 2021 08:33:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        reinette.chatre@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH v8 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
Message-ID: <YXOsx8SvFJV5R7lU@kroah.com>
References: <20211018135744.45527-1-jarkko@kernel.org>
 <20211018135744.45527-2-jarkko@kernel.org>
 <YW2GLE89WxAeMZH4@kroah.com>
 <4050b7723f6f205c9afc3bdfa3888a6e8befa12a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4050b7723f6f205c9afc3bdfa3888a6e8befa12a.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 23, 2021 at 04:02:48AM +0300, Jarkko Sakkinen wrote:
> On Mon, 2021-10-18 at 16:35 +0200, Greg Kroah-Hartman wrote:
> > > +               ret = sysfs_create_group(&dev->kobj, &sgx_node_attr_group);
> > 
> > A huge hint, if a driver has to call a sysfs_* call, something is wrong.
> > 
> > Something is wrong here.
> > 
> > Why are you messing around with a kobject?  This is a device, that you
> > control, you can just set the default attribute group for it and then
> > the driver core will add and remove the sysfs group at the proper time,
> > in the proper way.  Right now you are racing userspace and loosing.
> > 
> > Use the default group list, that is what it is there for.
> 
> I used sysfs_create_group() because node_devices is not owned by SGX
> code. It is managed in drivers/base/node.c, and also initialized before
> SGX.

Then that is broken, please do not use that device as your code does not
"own" it.  Or fix the logic to be initialized earlier.

thanks,

greg k-h

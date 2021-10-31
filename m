Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2002C433EF
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 19:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B0A60FC4
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 19:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhJaTdD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Oct 2021 15:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhJaTdB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Oct 2021 15:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A057860FBF;
        Sun, 31 Oct 2021 19:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635708629;
        bh=BF+Om5U+kwL7q9fToTe3AKKRtcGj4GK6C3df1fUvWfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eh8bYyqHgTVyh6FySzhcZH8m6PqgWMppRzRxl83dxm3je4h4RpX2RhodDGmJjDlHH
         W6Tdap7dEBWCvVTbHabXF1e7rcn26FZzI2b2zetVe9Brc5Sb3Ll4iIzlukU5Q9QiPa
         pjpS2Z7kpg1fymQQbhoyitS1AC5l1sDZxO18AO4I=
Date:   Sun, 31 Oct 2021 20:30:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH v9 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
Message-ID: <YX7uy3tZwBFQmAiR@kroah.com>
References: <20211029121857.477885-1-jarkko@kernel.org>
 <20211029121857.477885-2-jarkko@kernel.org>
 <YXwK7Wdi1VUK+1LS@kroah.com>
 <f0dc181d435cde51a9b81a70a0f47ff866d8cb91.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0dc181d435cde51a9b81a70a0f47ff866d8cb91.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 31, 2021 at 07:39:32PM +0200, Jarkko Sakkinen wrote:
> > > +static ssize_t size_show(struct device *dev, struct device_attribute *attr, char *buf)
> > > +{
> > > +       unsigned long size = 0;
> > > +       int nid;
> > > +
> > > +       for (nid = 0; nid < num_possible_nodes(); nid++) {
> > > +               if (dev == sgx_numa_nodes[nid].dev) {
> > > +                       size = sgx_numa_nodes[nid].size;
> > > +                       break;
> > > +               }
> > > +       }
> > > +
> > > +       return sysfs_emit(buf, "%lu\n", size);
> > > +}
> > > +DEVICE_ATTR_RO(size);
> > 
> > static?
> 
> The named ("sgx") attribute group is exported:
> 
> extern const struct attribute_group sgx_node_group;

That's fine, I am objecting to the fact that you now have added a global
symbol called device_attr_size.  Please make that static as that is a
VERY generic name.

thanks,

greg k-h

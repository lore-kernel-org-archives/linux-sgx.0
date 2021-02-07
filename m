Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57A1C433E0
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Feb 2021 21:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E6C164DEB
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Feb 2021 21:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhBGVRQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Feb 2021 16:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBGVRP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Feb 2021 16:17:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4819264DEB;
        Sun,  7 Feb 2021 21:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612732594;
        bh=Fh4DnJfPKioeK0dl0GS/tJXTIoYaLJPMwsSZy6RqyK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVYaLs9vdQk4PdiHamL/77B6OA8baHje6nA+kZPbpd9xjj0ALOIqb3MNZ390A0Crv
         moSV1k3TFVn7tZ+FQqRjR0v/Dvbs2SCPMc6mD1m/gvWswlOV86dM6etpeHOwH/NHaY
         PKDJvvssg+uekpEK2eknA1qjfzejw5ZZSFT4nl03ehFzmV9NgxUj2pgD+q2wx7hLc5
         KKgXkp0+ka8V1TzOv6Y3Iej2PcTVwXbDfVo326JRCBEkfMM1mLAa4U80M5TRDORcxT
         7ZS9yMY25M0sNOuvrVLlg0pYoyGK+OPzz4s6daIbEr1eIbUDW5tzL9mMFg7eii3cIZ
         VUggY5OQR6oJQ==
Date:   Sun, 7 Feb 2021 23:16:26 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] x86/sgx: Drop racy follow_pfn check
Message-ID: <YCBYqtPdFAxjkKhA@kernel.org>
References: <20210204184519.2809313-1-daniel.vetter@ffwll.ch>
 <YBys6Io1ZbZdzWmj@kernel.org>
 <CAKMK7uFM=ZW_+D32OGfirwY83ZkUKQpiA-3zGx9KAe1UKjW0XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFM=ZW_+D32OGfirwY83ZkUKQpiA-3zGx9KAe1UKjW0XQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 05, 2021 at 08:43:24AM +0100, Daniel Vetter wrote:
> On Fri, Feb 5, 2021 at 3:26 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > On Thu, Feb 04, 2021 at 07:45:19PM +0100, Daniel Vetter wrote:
> > > References: https://lore.kernel.org/dri-devel/20201127164131.2244124-1-daniel.vetter@ffwll.ch/
> >
> > What is the difference between this and "Link:" anyway?
> 
> Afaik References: is for other reading (bug reports, discussions,
> other patch series), Link: is for patch submission itself (which I
> think some subsystem do an entire chain of, on each revision). My
> scripts aren't good enough that they add the Link: before submitting,
> I add them when I apply patches (since most patches I get don't have
> them anyway).
> 
> btw since the final patch to remove follow_pfn won't be ready for 5.12
> merge window (kvm and vfio have some work to do) I think it's best if
> you just queue this up in your tree?

Boris has queued this to tip x86/sgx.

> Thanks, Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
> 

/Jarkko

Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD355C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 17 May 2022 00:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiEQAnS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 May 2022 20:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiEQAnO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 May 2022 20:43:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B22BB0C
        for <linux-sgx@vger.kernel.org>; Mon, 16 May 2022 17:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652748193; x=1684284193;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C64D2DyR7ERru5ThSyi8v1KJ7R0mRUKZaO8NOadgt9Q=;
  b=TuyxfbuQGl/c9zoxjFUzF+hSmMUsLsmQkjHPCXtIDW6KJAbhYb7ZYQCE
   Ce1I0vPc/tvjL8SCKcRgC5KU7Dy11J4sSa5dzY+IgUpYJoDwev9TsbHoA
   XdtrFDgBqiSD7iuff2gpF9c+8yrCscXTGptNxtfX1crjdFrvWH2+CMtHU
   Dc2UuztMXJQ4RoBl2vEzJyMdeYEkGDDchqWmmNCC8wFLIIsMNbEPluNPS
   NM8tX8VXQI15lsgOVIV1waF4boD4Em9gdJEGPv1TOUEpzt/OhJgvRW6PD
   ltySPnN7XlbI57rtO0eUd3PonkO4sAfkldaFBbPkDNynHoAyIymZp6Khc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="250904397"
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="250904397"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 17:43:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="713600992"
Received: from arbowles-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.1.22])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 17:43:12 -0700
Message-ID: <52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com>
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
From:   Kai Huang <kai.huang@intel.com>
To:     Zhiquan Li <zhiquan1.li@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>
Date:   Tue, 17 May 2022 12:43:10 +1200
In-Reply-To: <af6b22cf-bcc5-d1c1-e183-fb47200d58ab@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
         <YnuQJaM0p7gD5qel@kernel.org>
         <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
         <55ffd9475f5d46f68dd06c4323bec871@intel.com>
         <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
         <968e75d65a37ff7ae21f84875b78fb1ebbbef33d.camel@intel.com>
         <af6b22cf-bcc5-d1c1-e183-fb47200d58ab@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2022-05-16 at 16:40 +0800, Zhiquan Li wrote:
> On 2022/5/16 10:29, Kai Huang wrote:
> > On Sat, 2022-05-14 at 13:39 +0800, Zhiquan Li wrote:
> > > On 2022/5/14 00:35, Luck, Tony wrote:
> > > > > > Do you think the processes sharing the same enclave need to be killed,
> > > > > > even they had not touched the EPC page with hardware error?
> > > > > > Any ideas are welcome.
> > > > > I do not think the patch set is going to wrong direction. This discussion
> > > > > was just missing from the cover letter.
> > > OK, I will add this point into v2 of cover letter and patch 03.
> > > 
> > > 
> > I don't think you should add to patch 03.  The same enclave can be shared by
> > multiple processes is only true for host enclaves, but not virtual EPC isntance.
> > Virtual EPC instance is just a raw EPC resource which is accessible to guest,
> > but how enclaves are created on this EPC resource is completely upto guest. 
> > Therefore, one virtual EPC cannot be shared by two guests.
> > 
> 
> Thanks for your clarification, Kai.
> Patch 04 is for the host case, we can put it there.
> 
> May I add your comments in patch 03 and add you as "Acked-by" in v2?
> I suppose it is a good answer if someone has the same question.
> 

Yes you can add the comments to the patch.

One problem is currently we don't explicitly prevent vepc being shared via
fork().  For instance, an application can open /dev/sgx_vepc, mmap(), and
fork().  Then if the child does mmap() against the fd opened by the parent, the
child will share the same vepc with the parent.

We can either explicitly enforce that only one process can mmap() to one vepc in
mmap() of vepc, or we can put into comment saying something like below:

	Unlike host encalves, virtual EPC instance cannot be shared by multiple
	VMs.  It is because how enclaves are created is totally upto the guest.
	Sharing virtual EPC instance will very likely to unexpectedly break
	enclaves in all VMs.

	SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
	being shared by multiple VMs via fork().  However KVM doesn't support
	running a VM across multiple mm structures, and the de facto userspace
	hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
	this should not happen.

I'd like to hear from others whether simply adding some comment is fine.

-- 
Thanks,
-Kai



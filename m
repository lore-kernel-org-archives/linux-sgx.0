Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3501AC05027
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Feb 2023 22:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBQW31 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Feb 2023 17:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBQW31 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Feb 2023 17:29:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE955F82F
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 14:29:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C44D4B82E73
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 22:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AE1C433D2;
        Fri, 17 Feb 2023 22:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676672963;
        bh=fcmtIbdf12oSZqGKGgnshG0pMPeP7XpjlY2smt6s/fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S8ZYT3ONqsPlGjSzc45MQsWM9xVr1UEKKDkRDSsRzgkro+Y21CdDFoFDdCOaxMjXa
         mkXZtQ5jaUF4yGsfiC8i7F1/H8JGFKzBIEjXS48u37h09r8t/TePBEfEzMTKm3fmWR
         vvn/VQNOdW6RpELZm6+Ub0kq8KnqYp9O3s0KwtSo73X6+UDMLBXGxAb/ka1mk2U2fq
         4Uz9c0IfntdJOuj0CQWI7PK85E3/J34yThzlLuFhJmWJHkP7jpU24TD39P3XgO3iaN
         DaHCI2TQl8CIPYfi6goXMQ5CfFZ62RVTiBDMZlSWO9D/8uZ4hWtc5q38SIhCp0DJmI
         qRbvbhaeo8DuA==
Date:   Sat, 18 Feb 2023 00:29:18 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 4/4] selftests/sgx: Add test for madvise(...,
 WILLNEED)
Message-ID: <Y+//vtDmqjZjrR97@kernel.org>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <20230128045529.15749-4-haitao.huang@linux.intel.com>
 <20230128045529.15749-5-haitao.huang@linux.intel.com>
 <66db7859f696743b036c9dba3d040d196477984d.camel@intel.com>
 <op.10d4pvguwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <a9003c4ed2fac5a736a7317a3d4614de26bfb464.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9003c4ed2fac5a736a7317a3d4614de26bfb464.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 15, 2023 at 08:46:05AM +0000, Huang, Kai wrote:
> On Tue, 2023-02-14 at 22:42 -0600, Haitao Huang wrote:
> > On Tue, 14 Feb 2023 20:38:29 -0600, Huang, Kai <kai.huang@intel.com> wrote:
> > 
> > > On Fri, 2023-01-27 at 20:55 -0800, Haitao Huang wrote:
> > > > +/*
> > > > + * Compare performance with and without madvise call before EACCEPT'ing
> > > > + * different size of regions.
> > > > + */
> > > > +TEST_F_TIMEOUT(enclave, augment_via_madvise, TIMEOUT_DEFAULT)
> > > > +{
> > > > 
> > > [...]
> > > 
> > > > +
> > > > +	for (i = 0; i < self->encl.nr_segments; i++) {
> > > > +		struct encl_segment *seg = &self->encl.segment_tbl[i];
> > > > +
> > > > +		total_size += seg->size;
> > > > +	}
> > > > +
> > > > +	for (i = 1; i < 52 && advise_size < max_advise_size; i++) {
> > > > +		addr = mmap((void *)self->encl.encl_base + total_size, advise_size,
> > > > +			    PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,
> > > > +					self->encl.fd, 0);
> > > 
> > > I see the problem now.  Here 'pgoff' is always 0.  I think this is wrong.
> > > 
> > > Shouldn't you use the actual offset relative to the file as pgoff, which  
> > > is
> > > 	
> > > 	total_size >> PAGE_SHIFT
> > > 
> > > ?
> > > 
> > But that will be inconsistent with current usage. We have been using zero  
> > offset always including these self tests. The offset is also redundant in  
> > this case because it is totally defined by the address for a given enclave  
> > fd.
> > 
> > 
> 
> From mmap() manpage:
> 
>        void *mmap(void *addr, size_t length, int prot, int flags,
>                   int fd, off_t offset);
> 
>        The contents of a file mapping (as opposed to an anonymous
>        mapping; see MAP_ANONYMOUS below), are initialized using length
>        bytes starting at offset offset in the file (or other object)
>        referred to by the file descriptor fd.  offset must be a multiple
>        of the page size as returned by sysconf(_SC_PAGE_SIZE).
> 
> I think, conceptually, "always using 0 as offset to mmap() different offset of
> enclave file" is wrong.  You never encountered any issue is because SGX driver
> doesn't use vma->vm_pgoff as you mentioned.
> 
> I am not entire clear about SGX driver's history, so I am not sure SGX drvier,
> by design, has "relaxed semantics" of the offset parameter of mmap(), for
> instance, allow it to be any value.  But to me I see no reason SGX should have
> such relaxed semantics.
> 
> If you follow mmap() semantics, you won't need to manually set vma->vm_pgoff in
> sgx_mmap() (which is hacky IMHO) and everything just works.
> 
> Jarkko/Dave,
> 
> Do you have any comments?

I think I gave my feedback in my earlier comments so yeah I agree
with aligning anonymous semantics for sure.

BR, Jarkko

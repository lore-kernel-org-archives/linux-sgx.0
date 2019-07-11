Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3D7C74A56
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 14:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E71792166E
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 14:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="Ak3oiqM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfGKOcw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 10:32:52 -0400
Received: from usfb19pa11.eemsg.mail.mil ([214.24.26.82]:49393 "EHLO
        USFB19PA11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfGKOcw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 11 Jul 2019 10:32:52 -0400
X-EEMSG-check-017: 162675973|USFB19PA11_EEMSG_MP7.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by USFB19PA11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 11 Jul 2019 14:32:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1562855570; x=1594391570;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ia/iXlGcZBtjRBR3YX13UNiblz5vp05BNnipHsH4m8I=;
  b=Ak3oiqM6RsDVECXnWPvWMf/UwPs76XBpPDyoslHT7JhcmWpqS884Pmt0
   8Y6ycdbu0Rea4BdyPUeIdgRcxVccKcBdoYjEwh7uxli667J3zd1XJivCm
   mxetJY1GnLQVxGaW0lJqvd2z/gkoCbtLGw1UieEBAqZ+lmwkXsfCUQTa1
   xgWxOrvmY6klubvmi1R687LALCtY7i8aojtXLpbtTOofgTyCDoH0U4eW1
   4N2rzn4AvYMllMk29dtqzAYkK4414fbSHv1nPoyz9Bz7lhONEf9mWI68t
   ZOnSC3YWWMJzwXd9EnGcgbnZuMBFQ1OnfbW8/irMLH9P/u9XYwXg/uydK
   w==;
X-IronPort-AV: E=Sophos;i="5.63,478,1557187200"; 
   d="scan'208";a="30025926"
IronPort-PHdr: =?us-ascii?q?9a23=3AUbBorBb/HFqv4KGbaR4KxQz/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZpsq9Yx7h7PlgxGXEQZ/co6odzbaP6ea8CSdfv96oizMrSNR0TR?=
 =?us-ascii?q?gLiMEbzUQLIfWuLgnFFsPsdDEwB89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ?=
 =?us-ascii?q?/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL9vMhm6twrcu8oZjYZgK6s61w?=
 =?us-ascii?q?fErGZPd+lK321jOEidnwz75se+/Z5j9zpftvc8/MNeUqv0Yro1Q6VAADspL2?=
 =?us-ascii?q?466svrtQLeTQSU/XsTTn8WkhtTDAfb6hzxQ4r8vTH7tup53ymaINH2QLUpUj?=
 =?us-ascii?q?ms86tnVBnlgzocOjUn7G/YlNB/jKNDoBKguRN/xZLUYJqIP/Z6Z6/RYM8WSX?=
 =?us-ascii?q?ZEUstXWSNBGIe8ZJYRAeQHM+hTso3xq0IAoBa6AAWhAv7kxD1ViX/sxaA0zv?=
 =?us-ascii?q?ovEQ/G0gIjEdwBvnvbo9fpO6kdSu210KvFwC/fY/9K1zrw6o7FeQ0hr/GWWr?=
 =?us-ascii?q?JwdNLcx1QzFwzbllWQqZLqPzWI3eoQtmiU9e5gVeaxhG8ntgp8pSOvydo3io?=
 =?us-ascii?q?TSmoIUykzL9SV+wIovI924U1R0bcSrEJtXqSGXLo17Sd4sTWFvvSY10LwGuZ?=
 =?us-ascii?q?ijcSgR1psnwx/fa/qac4mH+hLjTuGRITVmi315ZLKznRGy8VKvyuD6S8K600?=
 =?us-ascii?q?5KozJYntTDuX0BzRze5tWdRvdj8UqtxyyD2x3V5+pZO047j7DbJIQkwrMok5?=
 =?us-ascii?q?oTtlnMETHulUXtia+Wal0k+u+16+T7ernmpoGTN4tzigzmLqQhgNa/AeUlMg?=
 =?us-ascii?q?gVRWSb5eS926Hj/U3+WrlKiOE5krLFv5zAIMQbp6q5DxdU0oYl9Rm/Ey+r3M?=
 =?us-ascii?q?kXkHQINl5IeA+Lg5L3N1zBPvz0F+qzj0ypkDhxxvDGOrPhAo/KLnjGiLrhZq?=
 =?us-ascii?q?ty61VHxQovzdFQ+5JUCrYbLPL1QU/+rsbUDhA+Mwyq2+rnEsly1psCWWKTBa?=
 =?us-ascii?q?+UKKHSvkWS5uIsIOmMY5UZuC3nJPgm5P7ujHk5lkEbfaSy2ZsXaXa4HulpIk?=
 =?us-ascii?q?mDYHrshMsBHnkOvgYkUOPqj1iCWyZJZ3muR6I8+i07CIW+AIjfWI+inaaB3C?=
 =?us-ascii?q?anEZFMaWFGC1aMEXjzeoWFXfcMdDydIst7njMYUrihTpcr1Quyuw/i17pnMu?=
 =?us-ascii?q?3U9zUDtZ39ztd14ffflRMo+TNoD8SdyWCNT3ponmMPXz823L5woVZmyleE16?=
 =?us-ascii?q?h1mP1YFdpP5/xXVgc2L4LTz+t/C9rqQALOYs+JSEq6QtWhGTwxStMxw9kTY0?=
 =?us-ascii?q?dyAtmilR/D3iWxDr8LmLyEGoY0/rjf33fvPcZ9zWjJ1K07g1khWMtPOnWshr?=
 =?us-ascii?q?Rj+AjLG47Jj0KZmr6udaQd2i7N6WiCwXOVvE5GTAFwTL/FXXEDZkrWtNj540?=
 =?us-ascii?q?TCQKKzCbQjLARM0tCCKqRUZd3zl1lGR+nsOM7YY22vn2e8HxGIxqmDbIDyYW?=
 =?us-ascii?q?USwD3dCFQYkwAU5XuGLhYxBiOgo2LYETxvGkniY13j8eZgsnO3VEw0wB+Qb0?=
 =?us-ascii?q?1nybW1/gQZhfuGS/McxrgEojsuqy1oHFah2NLbE9SBpwtlfKVYYNMy+lJH2X?=
 =?us-ascii?q?jFuABnJJygKLttiUAEcwRrpEPjzBR3CoNckcc0qHMm1hZ9KaWd0FlZbTOXwY?=
 =?us-ascii?q?jwOqHLKmn15B2gd7TZ2krA39eW4KsP8+g3q1X5swG0GEoi92to08NO3nud4J?=
 =?us-ascii?q?XKEBQdUZbrXkkr8Bh6oqnQYjMh6IPMyX1sLa60vyfA29IsA+sl0Aygf9ZEMK?=
 =?us-ascii?q?6fEg/9CcgaCNavKOAwnFipdB0ENvhI9KEoJ8Oma+eG2KmzMel9hj2mk3pI7J?=
 =?us-ascii?q?p90k2W8Sp8UfDH35AezvGZ2AuHSynzjFO7vs/rnoBEYCkYHnCjxij8GI5Req?=
 =?us-ascii?q?pycJ4PCWezP823wc5zh53zVH5C8l6sGVcG1NWueRqIYFz3xRdQ2lgPoXy7hS?=
 =?us-ascii?q?u4yCR5kzM3oaqD3CzO2ePieQEJOm5MXmlikU3jIY61j9EVRkSncw8plB6970?=
 =?us-ascii?q?bg26dbvLh/L3XUQUpQcCj2NX9tUqSru7WcZc5P6o0nsSFTUOS9fV+WUKLyox?=
 =?us-ascii?q?wf03CrI2wL5jkhdDKt8q7wnB97jm+bZCJxpWDaesY23h7c593aSPh52jsAWT?=
 =?us-ascii?q?k+iD/LC1z6NN6sq5Hc3afCtO/6H0msWodSemOjmYiNuDG67it6ABuwt/G1ht?=
 =?us-ascii?q?DjVwM91Hmo+cNtUHDzsBvkYoTtn5+/OOZjc1ggUETw8OJmC4p+lc02n5hW1n?=
 =?us-ascii?q?8E0MbGtUEbmHv+ZI0IkZn1a2AAEHtSmI/Y?=
X-IPAS-Result: =?us-ascii?q?A2BlAADRRydd/wHyM5BlGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?4FoBSpqUjKERJJeUwaBCQgliV6RFQkBAQEBAQEBAQErCQECAQGEQAKCUyM4E?=
 =?us-ascii?q?wEDAQEBBAEBAQEEAQFshTwMgjopAYJnAQUjBBFBEAsYAgImAgJXBg0IAQGCX?=
 =?us-ascii?q?z8BgXYUD6wpfzOFR4MqgUEGgQwoi18XeIEHgTgMgl8+h06CWASMToF0hiqVb?=
 =?us-ascii?q?wmCG4IfhDmNKgYbmAONM4dEkhUhgVgrCAIYCCEPO4Jti0WFWyMDgTYBAY8PA?=
 =?us-ascii?q?QE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 11 Jul 2019 14:32:48 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x6BEWfTs022959;
        Thu, 11 Jul 2019 10:32:43 -0400
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <20190710221638.bwnwtcozpv44ojdg@linux.intel.com>
 <38d3b0ee-be9c-cb1a-785a-325a3ade003b@intel.com>
 <20190711092609.jxe4uubwg5qbwfju@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <ef0c9052-d22e-aaa6-4915-b1823abea64c@tycho.nsa.gov>
Date:   Thu, 11 Jul 2019 10:32:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190711092609.jxe4uubwg5qbwfju@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/19 5:26 AM, Jarkko Sakkinen wrote:
> On Wed, Jul 10, 2019 at 04:16:42PM -0700, Xing, Cedric wrote:
>>> Still puzzling with EXECMOD given that how it is documented in
>>> https://selinuxproject.org/page/ObjectClassesPerms. If anything in that
>>> document is out of date, would be nice if it was updated.
>>
>> If you search for "EXECMOD" in security/selinux/hooks.c in the latest
>> (Linux-5.2) master, you'll find only one occurrence - at line 3702.
>>
>> The logic over there, if translated into English, basically says
>> FILE__EXECMOD is required (on the backing file) if mprotect() is called to
>> request X on a private file mapping that has been modified by the calling
>> process. That's what Sean meant by "W->X".
> 
> Looking at that part of code, there is this comment:
> 
> /*
>   * We are making executable a file mapping that has
>   * had some COW done. Since pages might have been
>   * written, check ability to execute the possibly
>   * modified content.  This typically should only
>   * occur for text relocations.
>   */
> 
> There is no COW done with enclaves, never. Thus, EXECMOD does not
> connect in any possible way to SGX. OR, that comment is false.
> 
> Which one is it?
> 
> Also the official documentation for SELinux speaks only about COW
> mappings.
> 
> Also the condition supports all this as a *private* file mapping ends up
> to the anon_vma list when it gets written. We have a *shared* file
> mapping
> 
> Nothing that you say makes sense to me, sorry...

The existing permissions don't map cleanly to SGX but I think Sean and 
Cedric were trying to make a best-effort approximation to the underlying 
concepts in a manner that permits control over the introduction of 
executable content.

Sure, the existing EXECMOD check is only applied today when there is an 
attempt to make executable a previously modified (detected based on COW 
having occurred) private file mapping.  But the general notion of 
controlling the ability to execute modified content is still meaningful.

In the case of regular files, having both FILE__WRITE and FILE__EXECUTE 
to the file is sufficient because that implies the ability to execute 
modified content.  And those FILE__* checks predated the introduction of 
EXECMOD and EXECMEM.

The mapping of /dev/sgx/enclave doesn't really fit existing categories 
because it doesn't provide the same semantics as a shared mapping of a 
regular file.  Userspace will always need both FILE__WRITE and 
FILE__EXECUTE to /dev/sgx/enclave.

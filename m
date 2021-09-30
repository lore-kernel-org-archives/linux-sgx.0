Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E36C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Sep 2021 14:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1256261A0C
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Sep 2021 14:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349735AbhI3OmF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350975AbhI3OmD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 Sep 2021 10:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ADA061A05;
        Thu, 30 Sep 2021 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633012820;
        bh=eGWInt/FzvKaXTE4LmAgwZmJ1/MWU+4nYjb3JiF7r7s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hRRGwJ9ZD7704af6cTWEjYQmaJGWdk4DsyJbSOT8V6rmNM73PEKLpovS/GPSwO+jJ
         JK5TmWG/rmJ1AAhgPlSb6jsFQwpbS/v0rouoOS6hMU7XJTjGR2Hj+muuEdQpjyubA9
         TE6eKDBqplhUYOAc4orLv8TNDswxEIPjeI7Nfe5CNg2xqGH0hCCifJXwcflzpjs7Uv
         sO6Tc5nl0yX1j/8w6ms/4ajQlvFHh2vxm0OYf725sapWngesRmTHU8f5nE+HnAQJse
         OtcVZLXtvsOCG+QNiGZAEUNYJgihhEfuTjLAkY9vKdUxu5MORl3crc/JJIvhVCc+kA
         6kFBWgvrmQsJQ==
Message-ID: <6e4e24ab222e0d8eba051cd01218a9b716217b7a.camel@kernel.org>
Subject: Re: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Date:   Thu, 30 Sep 2021 17:40:18 +0300
In-Reply-To: <YVOA1/AFFXmR6Uiw@agluck-desk2.amr.corp.intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
         <20210927213452.212470-1-tony.luck@intel.com>
         <20210927213452.212470-4-tony.luck@intel.com>
         <3efcda381b49651004e230f6ef008032842db1f9.camel@kernel.org>
         <ca3bb671a49141608ac981012091c3ea@intel.com>
         <1702295227b9276e051a0efee8af1475cba27407.camel@kernel.org>
         <YVOA1/AFFXmR6Uiw@agluck-desk2.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-09-28 at 13:53 -0700, Luck, Tony wrote:
> On Tue, Sep 28, 2021 at 11:11:30PM +0300, Jarkko Sakkinen wrote:
> > On Tue, 2021-09-28 at 15:41 +0000, Luck, Tony wrote:
> > > > > Add debugfs files /sys/kernel/debug/sgx/poison_page_list so that =
system
> > > > > administrators get a list of those pages that have been dropped b=
ecause
> > > > > of poison.
> > > >=20
> > > > So, what would a sysadmin do with that detailed information?
> > >=20
> > > It's going to be a rare case that there are any poisoned pages on tha=
t list
> > > (a large enough cluster will have some systems that have uncorrected
> > > recoverable errors in SGX EPC memory).
> > >=20
> > > Even when there are some poisoned pages, there will only be a few. Sy=
stems
> > > that have thousands of pages with uncorrected memory errors will sure=
ly crash
> > > because one of those errors is going to either trigger an error marke=
d as fatal,
> > > or the error won=E2=80=99t be recoverable by Linux because it is in k=
ernel memory.
> > >=20
> > > A sysadmin might add a script to run during system shutdown (or perio=
dically
> > > during run-time) to save the poison page list. Then at startup run:
> > >=20
> > > for addr in `cat saved_sgx_poison_page_list`
> > > do
> > > 	echo $addr > /sys/devices/system/memory/hard_offline_page
> > > done
> > >=20
> > > to make poison persistent across reboots.
> > >=20
> > > -Tony
> >=20
> > Couldn't it be a blob with 8 bytes for each address?
>=20
> It could be a blob. But that would require some perl/python
> instead of simple shell to do the above persistence trick.

The way I've understood it, a list of values breaks sysfs conventions.
There can be only single value per attribute. Even, if the blob is
interpreted as a list of integers, it is still a value, as far as sysfs
is concerned.

I'd also consider programs written with C, or perhaps Rust, when we
(ever) add any new sysfs for SGX. In my opinion, it makes sense to make
any uapi things we add accesible to as many tools as we can.

Such a trivially constructed blob is not enormously hard to parse in any
language, but at least I don't enjoy parsing list of strings in C code,
whereas loading a blob is effortless.

This kind of shows why the current sysfs conventions make sense in the
first place: they enforce to design attributes in the manner that they
are as reachable as possible. That's why I would follow the conventions
in a strict manner.

Finally, I would make a proper sysfs attribute out of this (and a separate
patch), which would be available per node.

/Jarkko


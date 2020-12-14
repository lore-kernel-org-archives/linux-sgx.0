Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F684C1B0D8
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Dec 2020 07:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5023D206CA
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Dec 2020 07:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgLNH0n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Dec 2020 02:26:43 -0500
Received: from mx2.uni-regensburg.de ([194.94.157.147]:58490 "EHLO
        mx2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLNH0m (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 14 Dec 2020 02:26:42 -0500
Received: from mx2.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 67747600004D;
        Mon, 14 Dec 2020 08:25:52 +0100 (CET)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx2.uni-regensburg.de (Postfix) with ESMTP id 48A62600004E;
        Mon, 14 Dec 2020 08:25:52 +0100 (CET)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Mon, 14 Dec 2020 08:25:51 +0100
Message-Id: <5FD7137E020000A10003D81B@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.0 
Date:   Mon, 14 Dec 2020 08:25:50 +0100
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <toiwoton@gmail.com>, <jarkko@kernel.org>
Cc:     <luto@amacapital.net>, "Ben Hutchings" <ben@decadent.org.uk>,
        <jethro@fortanix.com>, <bruce.schlobohm@intel.com>,
        <kai.svahn@intel.com>, <luto@kernel.org>,
        <haitao.huang@linux.intel.com>, <jarkko.sakkinen@linux.intel.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>, <casey@schaufler-ca.com>,
        <sds@tycho.nsa.gov>, <linux-hotplug@vger.kernel.org>,
        <linux-sgx@vger.kernel.org>
Subject: Antw: [EXT] Re: [systemd-devel] Creating executable device
 nodes in /dev?
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
 <20201211104635.GD12091@kernel.org>
 <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>
In-Reply-To: <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

>>> Topi Miettinen <toiwoton@gmail.com> schrieb am 11.12.2020 um 12:46 in
Nachricht
<27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>:
> On 11.12.2020 12.46, Jarkko Sakkinen wrote:
>> On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
>>> On 9.12.2020 2.15, Jarkko Sakkinen wrote:
>>>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>>>>> As  a further argument, I just did this on a Fedora system:
>>>>>>>> $ find /dev ‑perm /ugo+x ‑a \! ‑type d ‑a \! ‑type l
>>>>>>>> No results.  So making /dev noexec doesn't seem to have any benefit.
>>>>>>>
>>>>>>> It's no surprise that there aren't any executables in /dev since
>>>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>>>>> /dev is a writable directory (for UID=0 but no capabilities are
>>>>>>> needed) and thus a potential location for constructing unapproved
>>>>>>> executables if it is also mounted exec (W^X).
>>>>>>
>>>>>> UID 0 can just change mount options, though, unless SELinux or similar
is 
> used. And SELinux can protect /dev just fine without noexec.
>>>>>
>>>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also
SELinux
>>>>> is not universal and the policies might not contain all users or
services.
>>>>>
>>>>> ‑Topi
>>>>
>>>> What's the data that supports having noexec /dev anyway? With root
>>>> access I can then just use something else like /dev/shm mount.
>>>>
>>>> Has there been out in the wild real world cases that noexec mount
>>>> of would have prevented?
>>>>
>>>> For me this sounds a lot just something that "feels more secure"
>>>> without any measurable benefit. Can you prove me wrong?
>>>
>>> I don't think security works that way. An attacker has various methods to
>>> choose from, some are more interesting than others. The case where
rw,exec
>>> /dev would be interesting would imply that easier or more common avenues
>>> would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
>>> /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP
approach
>>> with no need for any file system access is getting more common. It does
not
>>> mean that it would not be prudent to block the relatively easy approaches
>>> too, including /dev.
>> 
>> What if we add a new mount option "chrexec", which allows exec
>> for character devices (S_IFCHR).
> 
> I think devices are a bad match for SGX because devices haven't been 
> executable and SGX is actually an operation for memory. So something 
> like memfd_create(, MFD_SGX) or mmap(,, PROT_READ|PROT_EXEC|PROT_SGX) 
> would be much more natural. Even better would be something that 
> conceptully also works for AMD version (either with the same flags or 
> MFD_SGX / MFD_whatever_the_AMD_version_is).

+1



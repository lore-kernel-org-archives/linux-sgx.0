Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD02C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Dec 2021 23:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhLQXz5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Dec 2021 18:55:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:29526 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhLQXz4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 Dec 2021 18:55:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639785356; x=1671321356;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to;
  bh=8ic5HRP0hUfp9pjtM6zY7EcFaIW1Fc9nJ5xo6C3cHcI=;
  b=DKoEeyLVjDopESIqpAo5yj0tTXaAiXGgN2+jr9f+sSWlcxTZUhX0PWdD
   PzWD9cOfda+UyRq+fub9c+Vpa54jduoUislSRlAdk9vjDTolNyeNQ1x18
   cbY/tauQxmBioxMNmz++ciVSdVuwB1HvbEEyiCtE2b8tWw7dx3G9lzP0v
   Ij7LvJDhfAsQyTggwV2WKk5TnrbQ7WKDgDyW8y7VgznnlYh4jhwg8eAuS
   fBDS0vcEV9zof/VjvM4943r5alXCePTf4YQrUcW48YGinu0Z9FBu54uu0
   MXXNiwE9Re9XywRwKcYVDpx6tqWt/Z3ctp8UrYH/oRl4IQPs8dkcYCM6c
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="220537976"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="220537976"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:55:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="683560612"
Received: from mkundu-mobl1.amr.corp.intel.com (HELO [10.212.216.75]) ([10.212.216.75])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:55:46 -0800
Subject: Re: [PATCH] x86/sgx: Fix NULL pointer dereference on non-SGX systems
To:     Greg KH <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     dave@sr71.net, nathan@kernel.org, jarkko@kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
References: <20211217223153.837591E0@davehans-spike.ostc.intel.com>
 <Yb0aHOuXV0L/691i@kroah.com> <Yb0dpXI7q0PmABk6@kroah.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <745c9724-531d-8138-801a-2b00e51c1fbf@intel.com>
Date:   Fri, 17 Dec 2021 15:55:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <Yb0dpXI7q0PmABk6@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------20347EE846A8586E19DB7734"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This is a multi-part message in MIME format.
--------------20347EE846A8586E19DB7734
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 12/17/21 3:30 PM, Greg KH wrote:
>>>
>>> diff -puN arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr arch/x86/kernel/cpu/sgx/main.c
>>> --- a/arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr	2021-12-17 13:38:00.217312383 -0800
>>> +++ b/arch/x86/kernel/cpu/sgx/main.c	2021-12-17 14:00:36.293044390 -0800
>>> @@ -906,7 +906,13 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
>>>  #ifdef CONFIG_NUMA
>>>  static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attribute *attr, char *buf)
>>>  {
>>> -	return sysfs_emit(buf, "%lu\n", sgx_numa_nodes[dev->id].size);
>>> +	unsigned long node_bytes = 0;
>>> +
>>> +	/* Avoid acccessing sgx_numa_nodes[] when it is not allocated: */
>>> +	if (!nodes_empty(sgx_numa_mask))
>>> +		node_bytes = sgx_numa_nodes[dev->id].size;
>>> +
>>> +	return sysfs_emit(buf, "%lu\n", node_bytes);
>>>  }
>> Why is this file showing up if we do not have sgx_numa_nodes not
>> allocated?  It shouldn't even be there to access then.
>>
>> don't return a fake number, just don't present the sysfs file at all.
> Or, if you _have_ to have the file present, return an error instead of a
> fake value.
> 
> But really, only create the file if the system supports it, that's the
> rule for sysfs and it makes it very easy to do so (see the is_visible
> callback for the attribute group for how to do it.)

Thanks for the suggestion!  That's a lot nicer.  It's also dirt simple
since we only have one attribute.  Updated patch is attached.

I'll send this out as a real v2 soon if no other issues pop up.

--------------20347EE846A8586E19DB7734
Content-Type: text/x-patch; charset=UTF-8;
 name="sgx-null-ptr.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="sgx-null-ptr.patch"


From: Dave Hansen <dave.hansen@linux.intel.com>

Nathan Chancellor reported an oops when aceessing the
'sgx_total_bytes' sysfs file:

	https://lore.kernel.org/all/YbzhBrimHGGpddDM@archlinux-ax161/

The sysfs output code accesses the sgx_numa_nodes[] array
unconditionally.  However, this array is allocated during SGX
initialization, which only occurs on systems where SGX is
supported.

If the sysfs file is accessed on systems without SGX support,
sgx_numa_nodes[] is NULL and an oops occurs.

To fix this, hide the entire nodeX/x86/ attribute group on
systems without SGX support using the ->is_visible attribute
group callback.

Fixes: 50468e431335 ("x86/sgx: Add an attribute for the amount of SGX mem=
ory in a NUMA node")
Reported-by: Nathan Chancellor <nathan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-sgx@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/kernel/cpu/sgx/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr arch/x86/kernel/cpu=
/sgx/main.c
--- a/arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr	2021-12-17 13:38:00.217=
312383 -0800
+++ b/arch/x86/kernel/cpu/sgx/main.c	2021-12-17 15:48:10.358932505 -0800
@@ -910,6 +910,13 @@ static ssize_t sgx_total_bytes_show(stru
 }
 static DEVICE_ATTR_RO(sgx_total_bytes);
=20
+static umode_t arch_node_attr_is_visible(struct kobject * kobj,
+		struct attribute * attr, int idx)
+{
+	/* Make all x86/ attributes invisible when SGX is not initialized: */
+	return !nodes_empty(sgx_numa_mask);
+}
+
 static struct attribute *arch_node_dev_attrs[] =3D {
 	&dev_attr_sgx_total_bytes.attr,
 	NULL,
@@ -918,6 +925,7 @@ static struct attribute *arch_node_dev_a
 const struct attribute_group arch_node_dev_group =3D {
 	.name =3D "x86",
 	.attrs =3D arch_node_dev_attrs,
+	.is_visible =3D arch_node_attr_is_visible,
 };
 #endif /* CONFIG_NUMA */
=20
_

--------------20347EE846A8586E19DB7734--
